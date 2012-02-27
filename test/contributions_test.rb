require 'teststrap'
require 'contributions'

context "Contributions::Contributions public api with a mocked .new" do
  hookup do
    stub(Contributions::GithubAPI).forks(anything) { ['r/r', 's/s'] }
  end

  setup { Contributions::Contributions.new(:username => 'charlietanksley') }

  context ".new" do
    context "assignments" do
      asserts_topic.assigns :username
      asserts_topic.assigns :repositories
    end

    asserts(:repositories).equals ['r/r', 's/s']
  end

  context ".add will add repositories" do
    context "if given a string" do
      setup { topic.add 'added/added' }
      asserts_topic.includes 'added/added'
    end

    context "if given an array" do
      setup { topic.add ['added/first', 'added/second'] }
      asserts_topic.includes 'added/first'
      asserts_topic.includes 'added/second'
    end
  end

  context ".contributions_as_hash" do
    context "does not reload hash if it already exists" do
    end
  end

  context ".only will trade out repositories" do
    context "if given a string" do
      setup { topic.only 'added/added' }
      asserts_topic.includes 'added/added'
      denies_topic.includes 'r/r'
      denies_topic.includes 's/s'
    end

    context "if given an array" do
      setup { topic.only ['added/first', 'added/second'] }
      asserts_topic.includes 'added/first'
      asserts_topic.includes 'added/second'
      denies_topic.includes 'r/r'
      denies_topic.includes 's/s'
    end
  end
  context ".project_names returns an array of project names" do
    asserts(:project_names).equals { ['r', 's'] }
  end

  context ".reload_contributions is an alias for .load_contributions" do
  end

  context ".remove will drop repositories" do
    context "if given a string" do
      setup { topic.remove 'r/r' }
      denies_topic.includes 'added/added'
    end

    context "if given an array" do
      setup { topic.remove ['r/r', 's/s'] }
      denies_topic.includes 'r/r'
      denies_topic.includes 's/s'
    end
  end



  # context "manipulators" do
  #   setup { Contributions::Contributions.new(:username => 'vim-scripts') }

  #   context "#remove will remove a single repository" do
  #     hookup { topic.repositories = ['r/r', 's/s', 't/t'] }
  #     asserts(:remove, 's/s').equals ['r/r', 't/t']
  #     asserts(:repositories).equals ['r/r', 't/t']
  #   end

  #   context "#remove will remove an array of repositories" do
  #     hookup { topic.repositories = ['r/r', 's/s', 't/t'] }
  #     asserts(:remove, ['r/r', 't/t']).equals ['s/s']
  #     asserts(:repositories).equals ['s/s']
  #   end

  #   context "#add will add a single repository" do
  #     hookup { topic.repositories = ['r/r', 's/s'] }
  #     asserts(:add, 't/t').equals ['r/r', 's/s', 't/t']
  #     asserts(:repositories).equals ['r/r', 's/s', 't/t']
  #   end

  #   context "#add will add an array of repositories" do
  #     hookup { topic.repositories = ['r/r'] }
  #     asserts(:add, ['s/s', 't/t']).equals ['r/r', 's/s', 't/t']
  #     asserts(:repositories).equals ['r/r', 's/s', 't/t']
  #   end


  # end

  # context "#contributions" do
  #   setup do
  #     Contributions::Contributions.new(:username => 'u')
  #   end

  #   hookup do
  #     mock(Contributions::GithubAPI).name('u') { 'Charlie Tanksley' }
  #     mock(Contributions::Git).contributions('Charlie Tanksley', 'thumblemonks/riot') { 'no way' }
  #   end

  #   asserts(:contributions, 'thumblemonks/riot').equals 'no way'
  # end

  # # context "#gather" do
  # #   setup { Contributions::Contributions.new(:username => 'u') }

  # #   context "asks for the forks, then determines the user's contributions for each" do
  # #     hookup do
  # #       mock(topic).forks { ['sinatra/sinatra'] }
  # #       mock(topic).contributions(anything).times(1) { Hash.new }
  # #     end

  # #     asserts(:gather).kind_of Hash
  # #   end
  # # end

  # # context "#forks" do
  # #   setup { Contributions::Contributions.new(:username => 'vim-scripts') }

  # #   context "adds the result of a GithubAPI.forks to the repositories ivar" do
  # #     helper(:repos) { ['vim-scripts/test.zip'] }
  # #     hookup do
  # #       mock(Contributions::GithubAPI).forks('vim-scripts') { repos }
  # #     end
  # #     asserts(:forks).equals ['vim-scripts/test.zip']
  # #   end
  # # end


  # context "#update" do
  #   context "changes nothing if there are no updates" do
  #     setup { Contributions::Contributions.new(:username => 'vim-scripts') }
  #     hookup { topic.repositories = ['s/s', 'h/h'] }

  #     asserts(:update).equals ['s/s', 'h/h']
  #   end

  #   context "alters the array as per execpt and add" do
  #     setup do
  #       Contributions::Contributions.new(:username => 'vim-scripts',
  #                                        :remove => ['h/h'],
  #                                        :add => ['r/r'])
  #     end
  #     hookup { topic.repositories = ['s/s', 'h/h'] }

  #     asserts(:update).equals ['s/s', 'r/r']
  #   end

  #   context "alters the array as per execpt and add" do
  #     setup do
  #       Contributions::Contributions.new(:username => 'vim-scripts',
  #                                        :only => ['h/h'])
  #     end
  #     hookup { topic.repositories = ['s/s', 'z/z'] }

  #     asserts(:update).equals ['h/h']
  #   end
  # end
end


context "Contributions::Contributions internal methods with a mocked .new" do
  hookup do
    mock(Contributions::GithubAPI).forks(anything) { ['r/r', 's/s'] }
  end

  setup { Contributions::Contributions.new(:username => 'charlietanksley') }

  context ".load_contributions" do
    context "actually calls out to get the contributions for each fork" do
    end

    context "returns a hash with repository names as keys" do
    end

    context "stashes the results in an instance variable" do
    end
  end
end
