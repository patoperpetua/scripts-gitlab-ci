# SINGLETON SD - SCRIPTS - GITLAB-CI

This project contains Linux bash scripts to use locally or in gitlab-ci templates and projects.

> The **main repository** is hosted in [gitlab.com/singletonsd/scripts/gitlab-ci](https://gitlab.com/singletonsd/scripts/gitlab-ci.git) but it is automaticaly mirrored to [github.com/singletonsd](https://github.com/singletonsd/scripts-gitlab-ci.git), [github.com/patoperpetua](https://github.com/patoperpetua/scripts-gitlab-ci.git) and to [gitlab.com/patoperpetua](https://gitlab.com/patoperpetua/scripts-gitlab-ci.git). If you are in the Github page it may occur that is not updated to the last version.

## AVAILABLE SCRIPTS

<!-- TODO: add scripts -->

## HOW TO USE

To use it, you can include them as following (using repository aproach):
<!-- TODO: add example to download from curl and wget. -->
```bash

```

Master branch is setup as latest folder. To use an specific version, put the version name before the file name like:

```yaml
include:
  - remote: 'https://singletonsd.gitlab.io/pipelines/angular/1.0.0/.gitlab-ci-main.yml'
  - remote: 'https://singletonsd.gitlab.io/singletonsd/pipelines/angular/develop/.gitlab-ci-test-main.yml'
  - remote: 'https://singletonsd.gitlab.io/singletonsd/pipelines/angular/feature-new/.gitlab-ci-main.yml'
```

And also define the stages you want to use. It can be both or just one. Remember to include the one you want or main if you use both, like following:

<!-- TODO: add stages-->
```yaml
stages:
```

## DOCUMENTATION

- [Shellcheck](https://github.com/koalaman/shellcheck)

## TODO

- [ ] Fix documentation.
- [X] Add gitlab lint test.
- [ ] Add script to download test script from gitlab pages.
- [ ] Zip all scripts and put inside pages.

----------------------

© [Singleton SD](http://www.singletonsd.com), Italy, 2019.
