# Examples

This repository provides samples and testing for running [sigs.k8s.io/kind](https://sigs.k8s.io/kind) on various CI platforms.

## Supported / Tested CI Platforms


For any platform not yet listed or listed as "Unsure :question:" we are looking for your help!
Please file Pull Requests and / or Issues for missing CI platforms :smile:

| Platform | Known to Work? | Status |
|---|---|--|
| [CircleCI](https://circleci.com/) | [Yes](.circleci) :heavy_check_mark: | [![CircleCI](https://circleci.com/gh/kind-ci/examples.svg?style=svg)](https://circleci.com/gh/kind-ci/examples) |
| [Travis CI](https://travis-ci.com/) | [Yes](.travis.yml) :heavy_check_mark: | [![Travis CI](https://travis-ci.com/kind-ci/examples.svg?branch=master)](https://travis-ci.com/kind-ci/examples/) |
| [Prow](https://github.com/kubernetes/test-infra/tree/master/prow) | [Yes](https://github.com/kubernetes/test-infra/tree/master/config/jobs/kubernetes-sigs/kind) :heavy_check_mark: | [![Prow](https://prow.k8s.io/badge.svg?jobs=ci-kind-build)](https://prow.k8s.io/?job=ci-kind-build) |
| [Concourse](https://concourse-ci.org/) | [Yes](concourse.md) :heavy_check_mark: | [![Concourse k8s](https://hush-house.pivotal.io/api/v1/teams/k8s-c10s/pipelines/kind/badge)](https://hush-house.pivotal.io/teams/k8s-c10s/pipelines/kind?group=all) |
| [Github](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/about-continuous-integration) | [Yes](.github/workflows/kind.yml) :heavy_check_mark: | ![Github](https://github.com/kind-ci/examples/workflows/Kind/badge.svg) |
| [Gitlab](https://about.gitlab.com/product/continuous-integration/) | [Yes](.gitlab-ci.yml) :heavy_check_mark: | ![Gitlab](https://gitlab.com/kind-ci/examples/badges/master/pipeline.svg) |
| [Azure Pipelines](https://azure.microsoft.com/en-us/services/devops/pipelines/) | [Yes](azure-pipelines.yml) :heavy_check_mark: | None |
| [Drone](https://drone.io/) | [Yes](./drone) :heavy_check_mark: | None |
| [Google Cloud Build](https://cloud.google.com/cloud-build/) | [Yes](./gcb.md) :heavy_check_mark: | None |
| [BuildKite](https://buildkite.com/) | Unsure :question: | None |
| [CodeShip](https://codeship.com/) | Unsure :question: | None |
