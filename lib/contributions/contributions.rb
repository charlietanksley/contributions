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
      GithubAPI.contributions GithubAPI.name(@username), repository_to_hash(repository)
    end

    # Internal: Split a 'username/repo_name' string into a hash.
    #
    # repository - 'username/repository_name'.
    #
    # Returns a Hash.
    def repository_to_hash(repository)
      r = repository.split('/')
      Hash[:username => r[0], :repository => r[1]]
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
