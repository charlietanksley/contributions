require 'teststrap'
require 'contributions/github_api'

context "Contributions::GithubAPI" do
  context ".forks" do
    setup { Contributions::GithubAPI.forks('charlietanksley') }

    context "gets a list of all the forks" do
      setup { topic.count }
      denies_topic.equals 0
    end

    context "gets the original names, not the name of the fork" do
      denies_topic.includes 'charlietanksley/riot'
      asserts_topic.includes 'thumblemonks/riot'
    end
  end

  context ".repos gets all the repositories when there are less than 100" do
    setup { Contributions::GithubAPI.repos('rubinius').count }
    
    asserts_topic.equals JSON.parse(open("https://api.github.com/users/rubinius") { |f| f.read })["public_repos"]
  end

  # Pending
  context ".repos gets all the repositories when there are tons" do
    # setup { Contributions::GithubAPI.repos('vim-scripts').count }
    
    # asserts_topic.equals JSON.parse(open("https://api.github.com/users/vim-scripts") { |f| f.read })["public_repos"]
  end

  context ".name returns the name of the user" do
    setup { Contributions::GithubAPI.name('charlietanksley') }
    asserts_topic.equals 'Charlie Tanksley'
  end

  context ".parent returns the name of the forked repository" do
    setup { Contributions::GithubAPI.parent('charlietanksley/riot') }
    asserts_topic.equals 'thumblemonks/riot'
  end
end
