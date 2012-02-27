require 'teststrap'
require 'contributions'

context "Contributions::Contributions" do
  hookup { RR.reset }
  helper(:full) { Contributions::Contributions.new(:username => 'charlietanksley') }

  context ".new finds out about all forks" do
    setup { full }
    asserts(:repositories).includes "msanders/snipmate.vim"
    asserts(:repositories).includes "thumblemonks/riot"
  end

  context ".new with an :only modifies the forks" do
    setup { Contributions::Contributions.new(:username => 'charlietanksley', :only => 'thumblemonks/riot') }
    asserts(:repositories).equals ['thumblemonks/riot']
  end

  context ".new with a :remove subtracts a fork" do
    setup { Contributions::Contributions.new(:username => 'charlietanksley', :remove => 'thumblemonks/riot') }
    denies(:repositories).includes 'thumblemonks/riot'
    asserts("we have subtracted 1") { full.repositories.count - topic.repositories.count == 1 }.equals true
  end

  context ".new will :remove with an array as an argument" do
    setup { Contributions::Contributions.new(:username => 'charlietanksley', :remove => ['thumblemonks/riot', 'rubinius/rubinius']) }
    denies(:repositories).includes 'thumblemonks/riot'
    denies(:repositories).includes 'rubinius/rubinius'
  end

  context ".new with an :add adds a fork" do
    setup { Contributions::Contributions.new(:username => 'charlietanksley', :add => 'thumblemonks/chicago') }
    asserts(:repositories).includes 'thumblemonks/chicago'
    asserts("we have added 1") { topic.repositories.count - full.repositories.count == 1 }.equals true
  end

  context ".new will :add with an array as an argument" do
    setup { Contributions::Contributions.new(:username => 'charlietanksley', :add => ['t/r', 'r/r']) }
    asserts(:repositories).includes 't/r'
    asserts(:repositories).includes 'r/r'
  end
end

context "a full run of Contributions::Contributions" do
  setup { Contributions::Contributions.new(:username => 'charlietanksley',
                                           :only => ['thumblemonks/riot', 'msanders/snipmate.vim', 'davetron5000/methadone']) }

  context "starts with a list of repositories" do
    asserts(:repositories).equals ['thumblemonks/riot', 'msanders/snipmate.vim', 'davetron5000/methadone']
  end

  context "does not start with any contributions" do
    asserts(:contributions).nil
  end

  context "grabs the contributions when asked" do

    context "with the right keys" do
      setup { topic.contributions_as_hash.keys }
      asserts_topic.includes 'thumblemonks/riot'
      asserts_topic.includes 'davetron5000/methadone'
    end

    context "and saves them off" do
      hookup { topic.contributions_as_hash }
      setup { topic.contributions.keys }
      asserts_topic.includes 'thumblemonks/riot'
      asserts_topic.includes 'davetron5000/methadone'
    end
  end

  context "when the list is updated" do
    hookup { topic.remove ['thumblemonks/riot', 'davetron5000/methadone'] }
    hookup { topic.load_contributions }
    asserts { topic.contributions_as_hash.keys }.equals []
    asserts(:contributions_as_hash).equals Hash[]
  end
end
