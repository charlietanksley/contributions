require 'teststrap'
require 'contributions'

context "Contributions" do
  context "::Contributions.new" do
    setup { Contributions::Contributions.new(:username => 'u') }
    asserts_topic.kind_of Contributions::Contributions
  end

  context "::Contributions.new takes a hash as an argument" do
    setup { Contributions::Contributions.new(:username => 'u') }

    asserts_topic.kind_of Contributions::Contributions
  end
end
