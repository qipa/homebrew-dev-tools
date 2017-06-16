# Description: generate `go_resource`s blocks for a Go package that uses Godep.
# Author: Baptiste Fontaine
# Usage:
#   brew go-resources [path]
#
# It'll use the current path if it's not given. Valid paths include the
# project's root, its Godeps directory, and its Godeps.json file, e.g.:
#
# $ git clone https://github.com/example/a-go-project.git
# $ brew go-resources a-go-project
#
# Note that some projects require more `go_resource`s than the ones specified
# in their Godeps.json, especially regarding build tools.

require "extend/string"

require "json"

class GoDep
  attr_reader :path, :revision, :url, :using

  def initialize(attrs)
    @path = attrs["ImportPath"]
    @revision = attrs["Rev"]

    case @path
    when %r{^(github\.com/[^/]+/[^/]+)}
      @path = Regexp.last_match(1)
      @url = "https://#{Regexp.last_match(1)}.git"
    when %r{^(code\.google\.com/p/(?:[^/]+))}
      @path = Regexp.last_match(1)
      @url = "https://#{@path}"
      @using = ":hg"
    when %r{^sourcegraph\.com/(.+)}
      @url = "https://github.com/#{Regexp.last_match(1)}.git"
    when %r{^(golang\.org/x/([^/]+))}
      @path = Regexp.last_match(1)
      @url = "https://go.googlesource.com/#{Regexp.last_match(2)}.git"
    when %r{^gopkg\.in/}
      @url = "https://#{@path}.git"
    when %r{^(google\.golang\.org/api)(?:/.+)}
      @path = Regexp.last_match(1)
      @url = "https://github.com/google/google-api-go-client.git"
    when %r{^(google\.golang\.org/cloud)(?:/.+)}
      @path = Regexp.last_match(1)
      @url = "https://code.googlesource.com/gocloud.git"
    else
      onoe "Unsupported path: #{@path}"
      @url = "FILL ME"
    end
  end

  def to_resource; <<-EOS
  go_resource "#{@path}" do
    url "#{@url}",
      :revision => "#{@revision}"#{", :using => #{@using}" if @using}
  end
    EOS
  end
end

class Godeps
  def initialize(spec)
    @spec = JSON.parse(File.read(spec))
  end

  def deps
    @deps || @deps = (@spec["Deps"] || []).map { |d| GoDep.new(d) }
  end

  def to_resources
    deps.uniq(&:path).map(&:to_resource) * "\n"
  end
end

root = Pathname.new(ARGV.shift || ".")
path = [root/"Godeps/Godeps.json", root/"Godeps.json", root].find(&:exist?)
unless path
  puts <<-EOS.undent
    Usage:
      brew go-resources <path>
  EOS
  exit 1
end

puts Godeps.new(path).to_resources
