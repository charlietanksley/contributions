require 'open-uri'
require 'json'

module Contributions
  class GithubAPI

    # Public: Get just the user's repositories that are forks.
    #
    # Returns an Array.
    def self.forks(username)
      self.repos(username)
          .select { |r| r["fork"] == true }
          .map { |r| r["owner"]["login"] + '/' + r["name"] }
    end

    # Public: Get the name of the user.
    #
    # username - github username.
    #
    # Returns a String.
    def self.name(username)
      self.user(username)["name"]
    end

    # Public: Get the name of the forked repository.
    #
    # repository - a 'username/repository_name' string.
    #
    # Returns a String.
    def self.parent(repository)
      username, repo_name = repository.split('/')
      repo_info = self.repository(repository)
      repo_info["parent"]["owner"]["login"] + '/' + repo_name
    end

    # Public: Get all the user's repositories.
    #
    # Returns an Array.
    def self.repos(username)
      JSON.parse(open("https://api.github.com/users/#{username}/repos?per_page=100") { |f| f.read } )
    end

    # Internal: Get the user info (all of it) from github.
    #
    # username - github username.
    #
    # Returns a Hash.
    def self.user(username)
      JSON.parse(open("https://api.github.com/users/#{username}") { |f| f.read } )
    end

    # Internal: Get the repository info (all of it) from github.
    #
    # repository - a 'username/repository_name' string.
    #
    # Returns a Hash.
    def self.repository(repository)
      JSON.parse(open("https://api.github.com/repos/#{repository}") { |f| f.read } )
    end

  end
end
