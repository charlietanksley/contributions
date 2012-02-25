module Contributions
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
