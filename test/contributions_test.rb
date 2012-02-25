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
    end

    hookup do
      mock(Contributions::GithubAPI).user('u') { 'Charlie Tanksley' }
      mock(Contributions::GithubAPI).contributions('Charlie Tanksley',
                                                   {:username => 'r', :repository => 'r'}) { 'no way' }
    end

    asserts(:contributions, 'r/r').equals 'no way'
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
