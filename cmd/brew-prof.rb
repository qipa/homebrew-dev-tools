#
# Description: run brew command with ruby profile
# Author: xu-cheng
# Usage:
#   brew prof <brew command>
# Example:
#   brew prof readall
#

Homebrew.install_gem_setup_path! "ruby-prof"
ENV["HOMEBREW_BREW_FILE"] = HOMEBREW_PREFIX/"bin/brew"
brew_rb = (HOMEBREW_LIBRARY_PATH/"../Homebrew/brew.rb").resolved_path
FileUtils.mkdir_p "prof"
exec "ruby-prof", "--printer=multi", "--file=prof", brew_rb, "--", *ARGV
