# `kind` on Google Cloud Build

This is very much a **hack**. Don't use this for real, take inspiration from it
at max!

The biggest hacks here are:
- using `awk` to "parse" out the port that exposes the APIServer from an URL in
  a yaml file
- the forwarding of the port from the host into the container where `kind` and
  the actual test is running:
  - inside the container, where `kind` and the actual test runs, we start a
    `socat` process which listens on a tcp port
  - when a connection to that port inside the container is made, we start
    another container in the host's network namespace. That container is able
    to connect to the exposed port on the host. Both `socat` processes are
    connected via their Stdin & Stdout.
  - we've essentially created a tunnel from within the container to the host
    for this one port
  - by default, `kind` exposes the APIServer on localhost (on the host), thus
    the kubeconfig file will hold something like `https://127.0.0.1:XXX/` as
    the server URL. Thus if we use the same port inside the container that
    `kind` has setup on the host, we can just use the same kubeconfig.

## Example `cloudbuild.yml`

The following cloud build config can be used by running

```sh
gcloud builds submit --config cloudbuild.yml --no-source
```

and will:

- download current version of `kubectl`
- compile `kind` from the tip of master
- run `kind` to create a cluster
- start a portforwarder to make the kube-apiserver accessible

There are two things which can be configured via `--substitutions`, none of
which is mandatory:
- `KIND_CONFIG`: a [configuration for kind][kind-config]
- `KIND_TESTS`: whatever should be run after the cluster hast been created,
  `KUBECONFIG` is setup for you

Examples on what the substitutions could look like can be found in the following `cloudbuild.yml`.

[kind-config]: https://kind.sigs.k8s.io/docs/user/quick-start/#configuring-your-kind-cluster

```yaml
steps:
- name: 'gcr.io/cloud-builders/git'
  args:
  - clone
  - https://github.com/kubernetes-sigs/kind
  - src/kind
- name: 'gcr.io/cloud-builders/docker'
  entrypoint: bash
  dir: bin
  args:
  - -c
  - |
    curl -L https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl > kubectl
    chmod 0750 kubectl
- name: golang
  dir: src/kind
  env:
  - CGO_ENABLED=0
  - GO111MODULE=on
  args:
  - go
  - build
  - -o
  - ../../bin/kind
- name: 'gcr.io/cloud-builders/docker'
  entrypoint: bash
  args:
  - -xeuc
  - |
    PATH="$${PATH}:$${PWD}/bin"

    {
      apt-get update -y
      apt-get install -y socat
    } >/dev/null

    kindArgs=( create cluster )

    if [ -n "$_KIND_CONFIG" ]
    then
      echo "$_KIND_CONFIG" > /tmp/kind-config.yml
      kindArgs+=( --config=/tmp/kind-config.yml )
    fi

    kind "$${kindArgs[@]}"

    KUBECONFIG="$$(mktemp)"
    kind get kubeconfig > "$$KUBECONFIG"
    export KUBECONFIG

    startForwarder() {
      local port
      # Gets the apiServerPort from the KUBECONFIG file.
      port="$( awk -F: '/server:/{ print $4 }' "$$KUBECONFIG" )"
      socat \
        TCP-LISTEN:${port},reuseaddr,fork \
        "EXEC:docker run --rm -i --network=host alpine/socat 'STDIO TCP-CONNECT:localhost:${port}'"
    }
    startForwarder &

    bash -xeuc "${_KIND_TESTS}"

substitutions:
  _KIND_TESTS: |
    kubectl get nodes -o wide
  _KIND_CONFIG: |
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
    - role: control-plane
    - role: worker
```
