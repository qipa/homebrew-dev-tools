#
# Description: run a ruby instance with Homebrew's library loaded.
# Author: xu-cheng
# Usage:
#   brew ruby <ruby options>
# Example:
#   brew ruby -e "puts :gcc.f.deps"
#   brew ruby script.rb
#
exec RUBY_PATH, "-I#{HOMEBREW_LIBRARY_PATH}", "-rglobal", "-rcmd/irb", *ARGV
