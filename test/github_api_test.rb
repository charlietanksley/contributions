require 'teststrap'
require 'contributions/github_api'

context "Contributions::GithubAPI" do
  context ".forks returns just the list of forks" do
    helper(:repos) do
      [{"clone_url"=>"https://github.com/vim-scripts/test.zip.git", "fork"=>true, "forks"=>1, "name"=>"test.zip", "owner"=>{"login"=>"vim-scripts", "id"=>443562}},
       {"clone_url"=>"https://github.com/vim-scripts/test_syntax.vim.git", "fork"=>false, "forks"=>1, "name"=>"test_syntax.vim"}]
    end

    hookup { mock(Contributions::GithubAPI).repos('vim-scripts') { repos } }
    setup { Contributions::GithubAPI.forks('vim-scripts') }

    asserts_topic.equals ['vim-scripts/test.zip']
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
end
