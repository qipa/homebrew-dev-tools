#:  * `resource-versions` <resource name>:
#: Print versions of resources with the given name in all formulas
#: Example:
#:   brew resource-versions cryptography

if ARGV.empty?
  puts "Usage:\n\tbrew resource-versions <resource name>"
  exit 1
end

require "formula"
package = ARGV.first
Formula
  .select { |f| f.resources.any? { |r| r.name == package } }
  .map { |f| [f.resources.select { |r| r.name == package }.first.version, f.full_name] }
  .sort
  .each { |version, name| puts "#{name},#{version}" }
