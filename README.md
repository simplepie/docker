<div align="center"><img src="logo.png" width="500"><br></div>

----

**SimplePie NG** is a modern, _next-generation_ PHP package for working with syndication feeds. It has been written from the ground-up to take advantage of the modern features of PHP 7.2+.

It starts with a completely different kind of thinking, and more than 15 years of experience in software engineering and open-source. It is written with a view of PHP from today and beyond, and is being built in such a way that greater community involvement should be far easier from much earlier in the project's life.

See the [Documentation](https://github.com/simplepie/simplepie-ng/wiki) or the [API Reference](https://simplepie.github.io/simplepie-ng/).

[![Medium](https://img.shields.io/badge/medium-simplepie--ng-blue.svg?style=for-the-badge)](https://medium.com/simplepie-ng)
[![Follow](https://img.shields.io/twitter/follow/simplepie_ng.svg?style=for-the-badge&label=Twitter)](https://twitter.com/intent/follow?screen_name=simplepie_ng)

## Badges

### Compliance

[![License](https://img.shields.io/github/license/simplepie/docker.svg?style=for-the-badge)](https://github.com/simplepie/docker/blob/master/LICENSE.md)

## Images

All of these images are built from the Alpine Linux variants of the [official PHP images](https://hub.docker.com/_/php). SimplePie-NG (and all related _modern_ SimplePie projects) officially supports the latest releases of 7.2 and 7.3.

These are designed for _local development_ with [Docker Desktop]. You can use `FROM simplepieng/base:{TAG}` in your own `Dockerfile` to build a production image, but you should only do so if you [consciously choose to trust the SimplePie core team](https://ryanparman.com/posts/2018/understanding-trust-in-your-infrastructure/).

* `7.2-cli-alpine3.9`
* `7.3-cli-alpine3.9`

### Notes about Alpine Linux

Alpine Linux is a popular Linux distribution for Docker containers because of its size. It builds on top of a project called [BusyBox] which uses [musl] (instead of [glibc] as the C/POSIX standard library implementation) and the [Almquist Shell] (Ash). This means that there are some differences between Alpine and your run-of-the-mill Debian, Ubuntu, RHEL, CentOS, or Amazon Linux distribution.

Differences in [musl] and [glibc] can lead to some small differences in behavior in PHP. Functions which map closely to the underlying C/C++ implementation are most likely to see differences (e.g., [strftime], [setlocale]).

Differences between [Bash] and [Ash][Almquist Shell] can also be a source of weirdness for newcomers. Fundamentally, you want to avoid Bash-isms [[1](https://wiki.ubuntu.com/DashAsBinSh), [2](https://mywiki.wooledge.org/Bashism), [3](https://linux.die.net/man/1/ash)]. Sticking to traditional POSIX shell compatibility is a requirement for any shell scripts you want to contribute to the project.

### simplepieng/base

Builds on top of the official PHP images by including the following PHP extensions, which are used by SimplePie NG or one of its underlying requirements.

* [curl](https://php.net/manual/en/book.curl.php)
* [ds](https://www.php.net/manual/en/book.ds.php)
* [intl](https://www.php.net/manual/en/book.intl.php)
* [json](https://www.php.net/manual/en/book.json.php)
* [mbstring](https://www.php.net/manual/en/book.mbstring.php)
* [opcache](https://www.php.net/manual/en/book.opcache.php)
* [xml](https://www.php.net/manual/en/book.xml.php)
* [xsl](https://www.php.net/manual/en/book.xsl.php)
* [zip](https://www.php.net/manual/en/book.zip.php)

### simplepieng/test-runner

Builds on `simplepieng/base` and simply adds [`make`](https://www.gnu.org/software/make/).

On launch, it automatically runs `make test` via the [`ENTRYPOINT`](https://docs.docker.com/engine/reference/builder/#entrypoint) statement. This behavior can be overridden to launch a shell when running the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) command and passing the `--entrypoint sh` option.

### simplepieng/test-coverage

## Please Support or Sponsor Development

[![Beerpay](https://img.shields.io/beerpay/simplepie/simplepie-ng.svg?style=flat-square)](https://beerpay.io/simplepie/simplepie-ng)

SimplePie NG is a labor of love. I have been working on it in my free time since June 2017 because it's a project I love, and I believe our community would benefit from this tool.

If you use SimplePie NG — especially to make money — it would be swell if you could kick down a few bucks. As the project grows, and we start leveraging more services and architecture, it would be great if it didn't all need to come out of my pocket.

You can also sponsor the development of a particular feature. If there's a feature that you want to see implemented, and I believe it's the right fit for SimplePie NG, you can sponsor the development of the feature to get it prioritized.

Your contributions are greatly and sincerely appreciated.

  [Almquist Shell]: https://en.wikipedia.org/wiki/Almquist_shell
  [Bash]: https://devhints.io/bash
  [BusyBox]: https://busybox.net/downloads/BusyBox.html
  [Docker Desktop]: https://hub.docker.com/search?q=docker%20desktop&type=edition&offering=community
  [glibc]: https://www.gnu.org/software/libc/
  [musl]: https://www.musl-libc.org
  [setlocale]: https://www.php.net/manual/en/function.setlocale.php
  [strftime]: https://php.net/manual/en/function.strftime.php
