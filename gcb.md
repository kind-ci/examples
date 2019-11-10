# `kind` on Google Cloud Build

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

There are two things to be configured via `--substitutions`:
- `KIND_CONFIG`: a [configuration for kind][kind-config] 
- `KIND_TESTS`: whatever should be run after the cluster hast been created, `KUBECONFIG` is setup for you

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

    export KUBECONFIG="$( kind get kubeconfig-path )"

    startForwarder() {
      local port
      port="$( awk -F: '/server:/{ print $4 }' "$$KUBECONFIG" )"
      socat \
        TCP-LISTEN:${port},reuseaddr,fork \
        "EXEC:docker run --rm -i --network=host alpine/socat 'STDIO TCP-CONNECT:localhost:${port}'"
    }
    startForwarder &

    bash -xeuc "${_KIND_TESTS}"

substitutions:
  _KIND_TESTS: 'kubectl get nodes -o wide'
  _KIND_CONFIG: ''
```
