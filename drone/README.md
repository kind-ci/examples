# DRONE PIPELINE EXAMPLE

An example drone pipeline using kind to create a kind cluster.

For the sake of simplicity all dependencies will be installed at runtime, but a more complete example can be found in the [fury-kubernetes-monitoring project](https://github.com/sighupio/fury-kubernetes-monitoring/blob/master/.drone.yml) using the image built from [fury-images](https://github.com/sighupio/fury-images/tree/master/kind).

We have chosen to use a docker service, sharing the docker socket with the pipeline step creating the cluster.
If access to the cluster is needed from successive steps, only the kubeconfig file has to be mounted and used as in the example.

## N.B.
- the project's repository has to be flagged as "trusted" from drone reposistory's settings due to the docker service having `privileged: true` set
- the teardown of the cluster will be managed from the docker service, no need to `kind delete cluster` explicitly
- the docker service name (here "docker") has to be added to "/apiServer/certSANs" as can be seen in the "kubeadmConfigPatchesJson6902" in [kind-config](./kind-config)
