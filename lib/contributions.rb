require "contributions/version"

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
      @repositories = gather unless @delay
      @contributions = Hash.new
    end

    # Public: Determine all the contributions for the user.
    #
    # Returns nothing.
    def gather
      forks.each do |f|
        @contributions.merge contributions(f)
      end

      @contributions
    end

    # Internal: Get the names of all the projects that the user has
    # forked and/or wants us to look into.
    #
    # Returns an Array.
    def forks
    end

    # Internal: Get the user's contributions to the repository.
    #
    # Returns a Hash.
    def contributions(repository)
    end


  end
end
