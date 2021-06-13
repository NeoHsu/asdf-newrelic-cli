<div align="center">

# asdf-newrelic-cli ![Build](https://github.com/NeoHsu/asdf-newrelic-cli/workflows/Build/badge.svg) ![Lint](https://github.com/NeoHsu/asdf-newrelic-cli/workflows/Lint/badge.svg)

[newrelic-cli](https://github.com/newrelic/newrelic-cli/blob/main/docs/GETTING_STARTED.md) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Build History

[![Build history](https://buildstats.info/github/chart/NeoHsu/asdf-newrelic-cli?branch=master)](https://github.com/NeoHsu/asdf-newrelic-cli/actions)

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, `unzip`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add newrelic-cli
# or
asdf plugin add newrelic-cli https://github.com/NeoHsu/asdf-newrelic-cli.git
```

newrelic-cli:

```shell
# Show all installable versions
asdf list-all newrelic-cli

# Install specific version
asdf install newrelic-cli latest

# Set a version globally (on your ~/.tool-versions file)
asdf global newrelic-cli latest

# Now newrelic-cli commands are available
newrelic --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/NeoHsu/asdf-newrelic-cli/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Neo Hsu](https://github.com/NeoHsu/)
