# homebrew-dev-tools
Development tools for Homebrew maintainers

## Installation

```
brew tap homebrew/dev-tools
```

## Adding new tools

Read the ["External Commands" Homebrew document](https://github.com/Homebrew/brew/blob/master/docs/External-Commands.md) to see how to create Homebrew external commands.

As a good practice, adding information on usage and origin as ruby comments is recommended.
A blank template can be found below.

```ruby
#
# Description: <a short discription of this tool>
# Author: <your name>
# Usage: <information on how to use this tool>
#
```
