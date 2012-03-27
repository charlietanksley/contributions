require 'teststrap'
require 'contributions'

context "a full-stack run of Contributions::Contributions" do
  hookup { RR.reset }
  setup { Contributions::Contributions.new(:username => 'charlietanksley') }

  context "starts with a list of repositories" do
    setup { topic.repositories }
    asserts_topic.includes 'GreenvilleRB/greenvillerb.github.com'
    asserts_topic.includes 'msanders/snipmate.vim'
  end

  context "does not start with any contributions" do
    asserts(:contributions).nil
  end

  context "when looking at two repositories" do
    hookup do
      topic.only ['GreenvilleRB/greenvillerb.github.com',
                        'msanders/snipmate.vim']
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

    context "you can force a reloading of the repositories" do
      hookup { topic.remove ['GreenvilleRB/greenvillerb.github.com'] }
      hookup { topic.load_contributions }
      asserts { topic.contributions_as_hash.keys }.equals []
      asserts(:contributions_as_hash).equals Hash[]
    end
  end
end
