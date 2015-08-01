#
# Description: run script for each formula
# Author: jacknagel
# Usage:
#   brew for-each-formula <ruby code>
# Example:
#   brew for-each-formula 'puts f.name'
#
# copied from https://github.com/jacknagel/dotfiles/blob/master/bin/brew-for-each-formula.rb
#

require "formula"
Formula.each { |f| eval(ARGV.first) }
