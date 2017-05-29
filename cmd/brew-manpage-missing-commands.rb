#
# Description: list Homebrew internal commands which aren't documented in manpage.
# Author: xu-cheng
# Usage:
#   brew manpage-missing-commands
#
#
require "cmd/commands"

manpage = File.read HOMEBREW_REPOSITORY/"Library/Homebrew/manpages/brew.1.md"
commands_in_manpage = manpage.scan(/\* `(.+)`[^`]*:/)
                             .flat_map { |m| m.first.split "`, `" }
                             .map { |m| m.sub(/ .*$/, "") }
                             .uniq

missing_commands = Homebrew.internal_commands - commands_in_manpage
extra_commands = commands_in_manpage - Homebrew.internal_commands \
  - HOMEBREW_INTERNAL_COMMAND_ALIASES.keys - %w[--version]

unless missing_commands.empty?
  puts "Missing commands:"
  puts_columns missing_commands
end

unless extra_commands.empty?
  puts
  puts "Extra commands:"
  puts_columns extra_commands
end
