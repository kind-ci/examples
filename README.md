# examples

Repository providing samples and testing for running sigs.k8s.io/kind on various CI services

## Supported/tested CI systems

| Has an Example | We Have CI on It | Platform |
|---|---|---|
| :heavy_check_mark:| :heavy_check_mark: | [CircleCI](.circleci) (#5)|
| :heavy_check_mark: | :heavy_check_mark: | [TravisCI](.travis.yml) (#4) |
| :x: | :x: |  BuildKite |
| :heavy_check_mark: | :heavy_check_mark: |[Prow](https://github.com/kubernetes/test-infra/tree/master/config/jobs/kubernetes-sigs/kind) |
| :heavy_check_mark: | :x: | Gitlab |
| :heavy_check_mark: | :x: | [Concourse](concourse.md) (#8) |
| :x: | :x: | Drone |
| :x: | :x: | GCB |
| :x: | :x: | Codeship [kubernetes-sigs/kind#523](https://github.com/kubernetes-sigs/kind/issues/523)
| :heavy_check_mark: | :x: | [Azure Pipelines](azure-pipelines.yml) |
