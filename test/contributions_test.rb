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
    setup { Contributions::Contributions.new(:username => 'charlietanksley', :delay => true) }

    context "passes the github api work off to a GithubAPI object" do
      hookup { mock(Contributions::GithubAPI).forks('charlietanksley') { Hash.new } }
      denies(:forks).nil
    end
  end
end
