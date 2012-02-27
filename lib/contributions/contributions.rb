require 'json'

module Contributions
  class Contributions

    # opts - a Hash with, at the very least, a username.  Optional
    #        arguments include :remove (to ignore some repository),
    #        :add (to add), and :only (to focus).
    def initialize(opts={})
      @username = opts.delete(:username)
      setup_repositories(opts)
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

    # Public: Return a user's OSS contributions as a hash.  If the hash
    # hasn't already been determined, the contributions are all looked
    # up and stashed in an ivar: @contributions.  If @contributions
    # already exists, it is returned without the costly lookup being
    # performed.
    #
    # Returns a Hash.
    def contributions_as_hash
      load_contributions unless @contributions
      @contributions
    end

    # Public: Determine a user's contributions and load the
    # @contributions ivar.
    #
    # Returns a Hash.
    def load_contributions
      @contributions = Hash.new
      repositories.each do |f|
        conts = get_contributions(f)
        @contributions[f] = conts unless conts.empty?
      end

      @contributions
    end

    # Public: Replace the user's forked repositories with the specified
    # repositories.
    #
    # repos - a 'username/repository_name' string, or an array of such
    #         strings.
    #
    # Returns the updated array of repositories.
    def only(repos)
      @repositories.only repos

      repositories
    end

    # Public: Provide the names for all the forked projects.
    #
    # Example:
    #
    #     user.repositories
    #     # => ['r/r', 's/s']
    #     user.project_names
    #     # => ['r', 's']
    #
    # Returns an Array.
    def project_names
      repositories.map { |s| s.match(/[^\/]*$/)[0] }
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

    # Public: Accessor method for the @repositories ivar.
    #
    # array - an array of 'username/repository_name' strings.
    #
    # Returns nothing.
    def repositories=(array)
      @repositories = RepositoryList.new(array)
    end

    # Public: Accessor method for the @repositories ivar.
    #
    # Returns an Array of 'username/repository_name' strings.
    def repositories
      @repositories.list
    end

    # Internal: Get the names of all the projects that the user has
    # forked and/or wants us to look into.
    #
    # Returns an Array.
    # def forks
    #   @repositories.add GithubAPI.forks(@username)
    #   update
    # end

    # Internal: attr_accessor for @contributions.  This method really only
    # exists for testing.
    #
    # hash - a hash.
    #
    # Returns a Hash.
    def contributions=(hash)
      @contributions = hash
    end

    # Internal: attr_reader for @contributions.  This method really only
    # exists for testing.
    #
    # Returns a Hash.
    def contributions
      @contributions
    end

    # Internal: Generate an array of forked repositories for the user.
    # This array is set as the @repositories variable.
    #
    # opts - an array with, possible, keys for :only, :remove, and :add.
    #
    # Returns an Array of repositories.
    def setup_repositories(opts)
      @repositories = RepositoryList.new(GithubAPI.forks(@username))
      update(opts)
    end

    # Internal: Get the user's contributions to the repository.
    #
    # Returns a Hash.
    def get_contributions(repository)
      Git.contributions GithubAPI.name(@username), repository
    end

    # Internal: Combine the user's explicit preferences with an array of
    # forks.
    #
    # Returns an Array.
    def update(opts)
      opts.each_pair do |k,v|
        @repositories.send(k.to_sym, v)
      end

      repositories
    end
  end
end
