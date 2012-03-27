require 'teststrap'
require 'contributions'

context "Contributions::Contributions" do
  hookup { RR.reset }
  setup { Contributions::Contributions.new(:username => 'charlietanksley') }

  context "starts with a list of repositories" do
    asserts(:repositories).equals ['GreenvilleRB/greenvillerb.github.com', 'msanders/snipmate.vim']
  end

  context "does not start with any contributions" do
    asserts(:contributions).nil
  end

  context "grabs the contributions when asked" do

    context "with the right keys" do
      setup { topic.contributions_as_hash.keys }
      asserts_topic.includes 'GreenvilleRB/greenvillerb.github.com'
      denies_topic.includes 'msanders/snipmate.vim'
    end

    context "and saves them off" do
      hookup { topic.contributions_as_hash }
      setup { topic.contributions.keys }
      asserts_topic.includes 'GreenvilleRB/greenvillerb.github.com'
      denies_topic.includes 'msanders/snipmate.vim'
    end
  end

  context "when the list is updated" do
    hookup { topic.remove ['GreenvilleRB/greenvillerb.github.com'] }
    hookup { topic.load_contributions }
    asserts { topic.contributions_as_hash.keys }.equals []
    asserts(:contributions_as_hash).equals Hash[]
  end
end
