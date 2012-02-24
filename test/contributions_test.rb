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
      asserts_topic.assigns :repositories, []
    end

    context "when evaluation is delayed" do
      setup { Contributions::Contributions.new(:username => 'u', :delay => true) }
      asserts_topic.assigns :delay, true
    end
  end

  context "#gather" do
    setup { Contributions::Contributions.new(:username => 'u', :delay => true) }

    context "asks github for the forks, then determines the user's contributions for each" do
      hookup do
        mock(topic).forks { ['sinatra/sinatra'] }
        mock(topic).contributions(anything).times(1) { Hash.new }
      end

      asserts(:gather).kind_of Hash
    end
  end
end
