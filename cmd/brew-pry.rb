#
# Description: run the interactive Homebrew Ruby shell powered by pry
# Author: xu-cheng
# Usage:
#   brew pry [--examples]
#

Homebrew.install_gem_setup_path! "pry"
require "pry"

class Symbol
  def f(*args)
    Formulary.factory(to_s, *args)
  end
end
class String
  def f(*args)
    Formulary.factory(self, *args)
  end
end

if ARGV.include? "--examples"
  puts "'v8'.f # => instance of the v8 formula"
  puts ":hub.f.installed?"
  puts ":lua.f.methods - 1.methods"
  puts ":mpd.f.recursive_dependencies.reject(&:installed?)"
else
  ohai "Interactive Homebrew Shell"
  puts "Example commands available with: brew pry --examples"
  Pry.config.prompt_name = "brew"
  Pry.start
end
