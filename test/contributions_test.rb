require 'teststrap'
require 'contributions'

context "Contributions" do
  context "::Contributions.new" do
    setup { Contributions::Contributions.new(:username => 'u') }
    asserts_topic.kind_of Contributions::Contributions

    context "assignments" do
      asserts_topic.assigns :username
      asserts_topic.assigns :delay
      asserts_topic.assigns :repositories
    end

    context "delayed evaluation" do
      setup { Contributions::Contributions.new(:username => 'u', :delay => true) }
      asserts_topic.assigns :delay, true
    end
  end
end
