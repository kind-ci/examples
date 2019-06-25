# `kind` on `concourse` with [`kind-on-c`][kind-on-c]

## Quick Intro

To run [kind] in a [concourse] task you can use [kind-on-c]. 
The project aims to provide an easy, nice, and "concourse-native" experience
for concourse pipeline authors by supplying a reusable concourse task
definition and task container.

[kind-on-c] supports primarily two modes:
- pull and run the node images provided by `kind`
- pull the source of kubernetes in a specific revision and create a node image
  on the fly

More information on supported kubernetes versions and features can be found at
[the project's github][kind-on-c] or its [automated test
pipeline][ci] (see also: [pipeline source][ci-src]).

## Example pipeline stub

```yaml
# ...
jobs:
- name: kind
  plan:
  - in_parallel:
    - get: kind-on-c
    - get: kind-release
      params:
        globs:
        - kind-linux-amd64
  - task: run-kind
    privileged: true
    file: kind-on-c/kind.yaml
    params:
      KIND_TESTS: |
        # your actual tests go here!
        kubectl get nodes -o wide
# ...
resources:
- name: kind-release
  type: github-release
  source:
    owner: kubernetes-sigs
    repository: kind
    access_token: <some github token>
    pre_release: true
- name: kind-on-c
  type: git
  source:
    uri: https://github.com/pivotal-k8s/kind-on-c
# ...
```

[kind]: //kind.sigs.k8s.io/
[concourse]: //concourse-ci.org/
[kind-on-c]: //github.com/pivotal-k8s/kind-on-c
[ci]: //wings.pivotal.io/teams/k8s-c10s/pipelines/kind
[ci-src]: //github.com/pivotal-k8s/kind-on-c/tree/master/ci/
