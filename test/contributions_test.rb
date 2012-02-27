require 'teststrap'
require 'contributions'

context "Contributions::Contributions" do
  setup { Contributions::Contributions.new(:username => 'charlietanksley') }

  context ".new" do
    context "assignments" do
      asserts_topic.assigns :username
      asserts_topic.assigns :repositories
    end

    context "finds out about all forks" do
      asserts(:repositories).includes "msanders/snipmate.vim"
      asserts(:repositories).includes "thumblemonks/riot"
    end
  end

  context "#contributions" do
    setup do
      Contributions::Contributions.new(:username => 'u')
    end

    hookup do
      mock(Contributions::GithubAPI).name('u') { 'Charlie Tanksley' }
      mock(Contributions::Git).contributions('Charlie Tanksley', 'thumblemonks/riot') { 'no way' }
    end

    asserts(:contributions, 'thumblemonks/riot').equals 'no way'
  end

  # context "#gather" do
  #   setup { Contributions::Contributions.new(:username => 'u') }

  #   context "asks for the forks, then determines the user's contributions for each" do
  #     hookup do
  #       mock(topic).forks { ['sinatra/sinatra'] }
  #       mock(topic).contributions(anything).times(1) { Hash.new }
  #     end

  #     asserts(:gather).kind_of Hash
  #   end
  # end

  # context "#forks" do
  #   setup { Contributions::Contributions.new(:username => 'vim-scripts') }

  #   context "adds the result of a GithubAPI.forks to the repositories ivar" do
  #     helper(:repos) { ['vim-scripts/test.zip'] }
  #     hookup do
  #       mock(Contributions::GithubAPI).forks('vim-scripts') { repos }
  #     end
  #     asserts(:forks).equals ['vim-scripts/test.zip']
  #   end
  # end

  context "manipulators" do
    setup { Contributions::Contributions.new(:username => 'vim-scripts') }

    context "#remove will remove a single repository" do
      hookup { topic.repositories = ['r/r', 's/s', 't/t'] }
      asserts(:remove, 's/s').equals ['r/r', 't/t']
      asserts(:repositories).equals ['r/r', 't/t']
    end

    context "#remove will remove an array of repositories" do
      hookup { topic.repositories = ['r/r', 's/s', 't/t'] }
      asserts(:remove, ['r/r', 't/t']).equals ['s/s']
      asserts(:repositories).equals ['s/s']
    end

    context "#add will add a single repository" do
      hookup { topic.repositories = ['r/r', 's/s'] }
      asserts(:add, 't/t').equals ['r/r', 's/s', 't/t']
      asserts(:repositories).equals ['r/r', 's/s', 't/t']
    end

    context "#add will add an array of repositories" do
      hookup { topic.repositories = ['r/r'] }
      asserts(:add, ['s/s', 't/t']).equals ['r/r', 's/s', 't/t']
      asserts(:repositories).equals ['r/r', 's/s', 't/t']
    end


  end

  context "#update" do
    context "changes nothing if there are no updates" do
      setup { Contributions::Contributions.new(:username => 'vim-scripts') }
      hookup { topic.repositories = ['s/s', 'h/h'] }

      asserts(:update).equals ['s/s', 'h/h']
    end

    context "alters the array as per execpt and add" do
      setup do
        Contributions::Contributions.new(:username => 'vim-scripts',
                                         :remove => ['h/h'],
                                         :add => ['r/r'])
      end
      hookup { topic.repositories = ['s/s', 'h/h'] }

      asserts(:update).equals ['s/s', 'r/r']
    end

    context "alters the array as per execpt and add" do
      setup do
        Contributions::Contributions.new(:username => 'vim-scripts',
                                         :only => ['h/h'])
      end
      hookup { topic.repositories = ['s/s', 'z/z'] }

      asserts(:update).equals ['h/h']
    end
  end
end
