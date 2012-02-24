require 'teststrap'
require 'contributions'

context "Contributions::Contributions" do
  context ".new" do
    setup do
      any_instance_of(Contributions::Contributions, :gather => [])
      Contributions::Contributions.new(:username => 'u')
    end

    context "assignments" do
      asserts_topic.assigns :username
      asserts_topic.assigns :delay
    end

    context "when evaluation is delayed" do
      setup { Contributions::Contributions.new(:username => 'u', :delay => true) }
      asserts_topic.assigns :delay, true
    end
  end

  context "#gather" do
    setup { Contributions::Contributions.new(:username => 'u', :delay => true) }

    context "asks for the forks, then determines the user's contributions for each" do
      hookup do
        mock(topic).forks { ['sinatra/sinatra'] }
        mock(topic).contributions(anything).times(1) { Hash.new }
      end

      asserts(:gather).kind_of Hash
    end
  end

  context "#forks" do
    helper(:repos) do
      [{"clone_url"=>"https://github.com/vim-scripts/test.zip.git", "fork"=>true, "forks"=>1, "name"=>"test.zip"},
       {"clone_url"=>"https://github.com/vim-scripts/test_syntax.vim.git", "fork"=>false, "forks"=>1, "name"=>"test_syntax.vim"}]
    end

    setup { Contributions::Contributions.new(:username => 'vim-scripts', :delay => true) }

    context "passes the github api work off to a GithubAPI object" do
      hookup { mock(Contributions::GithubAPI).repos('vim-scripts') { repos } }
      asserts(:forks).equals [{"clone_url"=>"https://github.com/vim-scripts/test.zip.git", "fork"=>true, "forks"=>1, "name"=>"test.zip"}]
    end
  end
end

context "Contributions::GithubAPI" do
  context ".repos gets all the repositories when there are less than 100" do
    setup { Contributions::GithubAPI.repos('rubinius').count }
    
    asserts_topic.equals JSON.parse(open("https://api.github.com/users/rubinius") { |f| f.read })["public_repos"]
  end

  # Pending
  context ".repos gets all the repositories when there are tons" do
    # setup { Contributions::GithubAPI.repos('vim-scripts').count }
    
    # asserts_topic.equals JSON.parse(open("https://api.github.com/users/vim-scripts") { |f| f.read })["public_repos"]
  end
end
