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
      @repositories = RepositoryList.new
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
      @repositories.add GithubAPI.forks(@username)
      update
    end

    # Internal: Get the user's contributions to the repository.
    #
    # Returns a Hash.
    def contributions(repository)
      @repositories.key_value_pairs.each do |e|
        GithubAPI.contributions(e)
      end
    end


    # Internal: Combine the user's explicit preferences with an array of
    # forks.
    #
    # Returns an Array.
    def update
      @addtional_repository_information.each_pair do |k,v|
        @repositories.send(k.to_sym, v)
      end

      repositories
    end

    def repositories=(array)
      @repositories = RepositoryList.new(array)
    end

    def repositories
      @repositories.list
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

  class RepositoryList

    attr_reader :list

    def initialize(*args)
      @list = [args].flatten
    end

    # Public: Add a string or array of strings to the repository list.
    #
    # repos - a string or an array of strings (each of which is a
    #         'username/repo')
    #
    # Returns a RepositoryList
    def add(repos)
      @list.push(repos).flatten!
      self
    end

    # Public: Turn repositories into key value pairs.
    #
    # Returns an Array of Hashes {:username, :repository}
    def key_value_pairs
      results = []
      @list.each do |e|
        p = e.split('/')
        results.push Hash[:username => p[0], :repository => p[1]]
      end

      results
    end

    # Public: Replace list of repositories with the list provided.
    #
    # repos - a string or an array of strings (each of which is a
    #         'username/repo')
    #
    # Returns a RepositoryList
    def only(repos)
      @list = [repos].flatten
      self
    end

    # Public: Remove a string or array of strings from the repository
    # list.
    # repos - a string or an array of strings (each of which is a
    #         'username/repo')
    #
    # Returns a RepositoryList
    def remove(repos)
      @list.delete_if { |e| [repos].flatten.include? e }
      self
    end
  end
end
