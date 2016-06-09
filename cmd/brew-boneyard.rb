#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
# Description: boneyard a formula from homebrew/core.
#   This assumes you have a personal fork of both the homebrew/core and
#   homebrew/boneyard tap repos. It:
#     * creates a new branch on both repos
#     * removes the formula from homebrew/core and lists it in tap_migrations.json
#     * adds it in the boneyard repo
#     * commits and pushes in both repos
#     * opens PR creation pages for both in your browser
#   Uses the "git config github.user" setting to determine your GitHub user
#
# Author: Baptiste Fontaine
# Usage:
#   brew boneyard <core-formula>

github_user = `git config github.user`.chomp
raise "Please run git --global --add github.user your_username" if github_user == ""

core_repo = "#{github_user}/homebrew-core"
core_remote = "git@github.com:#{core_repo}.git"

boneyard_repo = "#{github_user}/homebrew-boneyard"
boneyard_remote = "git@github.com:#{boneyard_repo}.git"

migrations = "#{HOMEBREW_REPOSITORY}/Library/Taps/homebrew/homebrew-core/tap_migrations.json"
source_dir = "#{HOMEBREW_REPOSITORY}/Library/Taps/homebrew/homebrew-core/Formula"
target_dir = "#{HOMEBREW_REPOSITORY}/Library/Taps/homebrew/homebrew-boneyard"
raise "Please run brew tap homebrew/boneyard" unless File.exist? target_dir

ARGV.named.each do |name|
  branch = "#{name}-boneyard"
  file = "#{name}.rb"

  source = "#{source_dir}/#{file}"
  target = "#{target_dir}/#{file}"

  raise "Source file #{source} doesn't exist" unless File.exist? source
  raise "Target file #{target} already exists" if File.exist? target

  FileUtils::Verbose.mv source, target

  # hacky way to add a line in the tap_migrations.json file
  mlines = File.read(migrations).lines
  first_line = mlines[0]
  last_line = mlines[-1]
  File.open(migrations, "w") do |f|
    f.write first_line
    m = mlines.slice(1..-2).map { |s| s.sub(/,?\n?$/, "") }
    m << "  \"#{name}\": \"homebrew/boneyard\""
    m.sort!
    f.write(m.join(",\n")+"\n")
    f.write last_line
  end

  FileUtils::Verbose.cd source_dir do
    system "git", "checkout", "master"
    system "git", "checkout", "-b", branch
    system "git", "add", file, migrations
    system "git", "commit", "-m", "#{name}: migrate to boneyard"
    system "git", "push", "-u", core_remote, branch
    system "git", "checkout", "master"
  end

  FileUtils::Verbose.cd target_dir do
    system "git", "checkout", "master"
    system "git", "checkout", "-b", branch
    system "git", "add", file
    system "git", "commit", "-m", "#{name}: migrate from core"
    system "git", "push", "-u", boneyard_remote, branch
    system "git", "checkout", "master"
  end

  sleep 0.2 # wait for GitHub to process the new stuff
  system "open", "https://github.com/#{core_repo}/compare/#{branch}?expand=1"
  system "open", "https://github.com/#{boneyard_repo}/compare/#{branch}?expand=1"
end
