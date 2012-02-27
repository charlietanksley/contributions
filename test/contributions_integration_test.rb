require 'teststrap'
require 'contributions'

context "Contributions::Contributions with unmocked .new" do
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

