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

  context "#contributions" do
    setup do
      Contributions::Contributions.new(:username => 'u', :delay => true)
      # topic.repositories
    end
    asserts(:contributions, 'rubinius/rubinius').equals 'no way'
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
    setup { Contributions::Contributions.new(:username => 'vim-scripts', :delay => true) }

    context "adds the result of a GithubAPI.forks to the repositories ivar" do
      helper(:repos) { ['vim-scripts/test.zip'] }
      hookup do
        mock(Contributions::GithubAPI).forks('vim-scripts') { repos }
      end
      asserts(:forks).equals ['vim-scripts/test.zip']
    end
  end

  context "#update" do
    context "changes nothing if there are no updates" do
      setup { Contributions::Contributions.new(:username => 'vim-scripts', :delay => true) }
      hookup { topic.repositories = ['s/s', 'h/h'] }

      asserts(:update).equals ['s/s', 'h/h']
    end

    context "alters the array as per execpt and add" do
      setup do
        Contributions::Contributions.new(:username => 'vim-scripts',
                                         :delay => true,
                                         :remove => ['h/h'],
                                         :add => ['r/r'])
      end
      hookup { topic.repositories = ['s/s', 'h/h'] }

      asserts(:update).equals ['s/s', 'r/r']
    end

    context "alters the array as per execpt and add" do
      setup do
        Contributions::Contributions.new(:username => 'vim-scripts',
                                         :delay => true,
                                         :only => ['h/h'])
      end
      hookup { topic.repositories = ['s/s', 'z/z'] }

      asserts(:update).equals ['h/h']
    end
  end
end

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
end

context "RepositoryList" do
  context "#add" do
    context "with a blank canvas" do
      setup { Contributions::RepositoryList.new }

      context "adds a single string" do
        hookup { topic.add('rubinius/rubinius') }
        asserts(:list).equals ['rubinius/rubinius']
      end

      context "adds an array of strings" do
        hookup { topic.add ['rubinius/rubinius', 'vim-scripts/test.vim'] }
        asserts(:list).equals ['rubinius/rubinius', 'vim-scripts/test.vim']
      end
    end

    context "with a starting array" do
      setup { Contributions::RepositoryList.new(['s/s']) }

      context "adds a single string" do
        hookup { topic.add 'rubinius/rubinius' }
        asserts(:list).equals ['s/s', 'rubinius/rubinius']
      end

      context "adds an array of strings" do
        hookup { topic.add ['rubinius/rubinius', 'vim-scripts/test.vim'] }
        asserts(:list).equals ['s/s', 'rubinius/rubinius', 'vim-scripts/test.vim']
      end
    end
  end

  context "#remove" do
    setup { Contributions::RepositoryList.new(['s/s', 's/ss', 'o/other']) }

    context "selectively removes a single repo" do
      hookup { topic.remove 's/s' }
      asserts(:list).equals ['s/ss', 'o/other']
    end

    context "selectively removes an array of repos" do
      hookup { topic.remove ['s/s', 's/ss'] }
      asserts(:list).equals ['o/other']
    end
  end

  context "#only completely replaces the list" do
    setup { Contributions::RepositoryList.new(['s/s', 's/ss', 'o/other']) }

    context "when given a single repo" do
      hookup { topic.only 'a/a' }
      asserts(:list).equals ['a/a']
    end

    context "when given an array" do
      hookup { topic.only ['a/a', 'b/b'] }
      asserts(:list).equals ['a/a', 'b/b']
    end
  end

  context "#key_value_pairs splits into key value pairs" do
    setup { Contributions::RepositoryList.new(['s/s', 's/ss', 'o/other']) }
    asserts(:key_value_pairs).equals [{:username => 's', :repository => 's'},
                                      {:username => 's', :repository => 'ss'},
                                      {:username => 'o', :repository => 'other'}]
  end

end

