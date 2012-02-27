# TODO: Something is wrong with the .repositories method.  I don't know
# why, but it it returning an empty array.  And that is messing things
# up.  Big time.
require 'json'

module Contributions
  class Contributions

    # opts - a Hash with, at the very least, a username.  Optional
    #        arguments include :remove (to ignore some repository),
    #        :add (to add), and :only (to focus).
    def initialize(opts={})
      @username = opts.delete(:username)
      @addtional_repository_information = opts
      setup_repositories
      # @contributions = gather unless @delay
    end

    # Public: Add a repository (or array of repositories).
    #
    # repos - a 'username/repository' String or Array of such strings.
    #
    # Returns the updated array of repositories.
    def add(repos)
      @repositories.add(repos)

      repositories
    end

    # Public: Return a user's OSS contributions as a hash.
    #
    # Returns a Hash.
    def contributions_as_hash
      @contributions
    end

    # Public: Return a user's OSS contributions as JSON.
    #
    # Returns JSON.
    def contributions_as_json
      JSON.generate(@contributions)
    end


    # Public: Determine all the contributions for the user.
    #
    # Returns nothing.
    def gather
      conts = Hash.new
      forks.each do |f|
        conts[f] = contributions(f)
      end

      conts
    end

    # Public: Remove a repository (or array of repositories).
    #
    # repos - a 'username/repository' String or Array of such strings.
    #
    # Returns the updated array of repositories.
    def remove(repos)
      @repositories.remove(repos)

      repositories
    end

    # Internal: Get the names of all the projects that the user has
    # forked and/or wants us to look into.
    #
    # Returns an Array.
    def forks
      @repositories.add GithubAPI.forks(@username)
      update
    end

    def setup_repositories
      @repositories = RepositoryList.new
      forks
    end

    # Internal: Get the user's contributions to the repository.
    #
    # Returns a Hash.
    def contributions(repository)
      Git.contributions GithubAPI.name(@username), repository
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
end
