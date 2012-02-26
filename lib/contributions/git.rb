require 'tmpdir'
require 'contributions/string_utils'

module Contributions
  class Git

    ENDING    = " CONTRIBUTIONS_ENDING "
    KEYS      = [:sha, :date, :subject, :body]
    SEPARATOR = " CONTRIBUTIONS_SEPARATOR "

    # Public: Get all the contributions in a repository by a user
    # (contributions for which the user is the *author*).
    #
    # user       - a user's name (the name that shows up as the committer or
    #              author---e.g., 'John Smith'
    # repository - a 'username/repository_name' string.
    #
    # Returns an Array of Hashes with keys for :sha, :date, :subject, :body
    def self.contributions(user, repository)
      log = self.clone(repository) { self.read_log(user) }
      StringUtils.string_to_hash(log, KEYS, SEPARATOR, ENDING)
    end

    # Public: Clone a repository and run the block passed inside the
    # newly cloned repository.
    #
    # repository - a 'username/repository_name' string.
    # block      - a block to be executed inside the newly cloned
    #              directory.
    #
    # Returns the return value of the block.
    def self.clone(repository, &block)
      value = ''
      repo_name = repository.match(/([^\/]*$)/)[1]
      Dir.mktmpdir(repo_name) do |dir|
        cloned_repo_name = dir + '/' + repo_name
        system "git clone -q https://github.com/#{repository} #{cloned_repo_name}"
        Dir.chdir(cloned_repo_name) do
          value = yield
        end
      end

      value
    end

    # Internal: The command to read the git log.
    #
    # user - the user's name.
    #
    # Returns nothing.
    def self.read_log(user)
      # We want a string returned (for parsing); so use read over
      # readlines.
      IO.popen("git log --author='#{user}' --format='#{self.log_format}' --no-color") { |io| io.read }
    end

    def self.log_format
      ["%h", "%ci", "%s", "%b"].join(SEPARATOR) << ENDING
    end


  end
end
