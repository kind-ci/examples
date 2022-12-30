# `kind` on AWS Codebuild

Below is an example buildspec that works with codebuild image `aws/codebuild/standard5.0` (Ubuntu Standard 5). The Amazon Linux 2 images [do not seem to work][https://github.com/kubernetes-sigs/kind/issues/1383]

## Example buildspec

```buildspec.yml
version: 0.2

phases:
  install:
    runtime-versions:
        golang: 1.16
  build:
    commands:
      - export GO111MODULE=on
      - export PATH=$PATH:$(go env GOPATH)/bin
      - go install sigs.k8s.io/kind@v0.17.0
      - kind create cluster --wait 5m --config kind-config.yaml 
      # TODO: find a better way poll things work
      - sleep 300
```

## Notes

- About 1-2% of the time, KIND fails to start. The failure happens immediately; it looks like it's related to some race condition between codebuild setting up it's docker plane and KIND attempting to use docker. Always on a restart KIND (and the build) succeeds.