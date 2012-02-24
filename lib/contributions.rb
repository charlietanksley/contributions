require "contributions/version"
require 'open-uri'
require 'json'

module Contributions
  class Contributions

    # opts - a Hash with, at the very least, a username.  Optional
    #        arguments include :delay (set to true to delay evaluation),
    #        :execpt (to ignore some repository), :plus (to add), and :only (to
    #        focus).
    def initialize(opts={})
      @username = opts.delete(:username)
      @delay = opts.delete(:delay) || false
      @addtional_repository_information = opts
      @contributions = gather unless @delay
    end

    # Public: Determine all the contributions for the user.
    #
    # Returns nothing.
    def gather
      conts = Hash.new
      forks.each do |f|
        conts.merge contributions(f)
      end

      conts
    end

    # Internal: Get the names of all the projects that the user has
    # forked and/or wants us to look into.
    #
    # Returns an Array.
    def forks
      update(GithubAPI.forks(@username))
    end

    # Internal: Get the user's contributions to the repository.
    #
    # Returns a Hash.
    def contributions(repository)
    end

  end

  class GithubAPI

    # Public: Get just the user's repositories that are forks.
    #
    # Returns an Array.
    def self.forks(username)
      self.repos(username)
          .select { |r| r["fork"] == true }
          .map { |r| r["owner"]["login"] + '/' + r["name"] }
    end

    # Public: Get all the user's repositories.
    #
    # Returns an Array.
    def self.repos(username)
      JSON.parse(open("https://api.github.com/users/#{username}/repos?per_page=100") { |f| f.read } )
    end
  end
end

