require 'teststrap'
require 'contributions/repository_list'

context "RepositoryList" do
  context "#add" do
    context "with a blank canvas" do
      setup { Contributions::RepositoryList.new }

      context "adds a single string" do
        hookup { topic.add('rubinius/rubinius') }
        asserts(:list).equals ['rubinius/rubinius']
      end

      context "adds an array of strings" do
        hookup { topic.add ['rubinius/rubinius', 'vim-scripts/test.vim'] }
        asserts(:list).equals ['rubinius/rubinius', 'vim-scripts/test.vim']
      end
    end

    context "with a starting array" do
      setup { Contributions::RepositoryList.new(['s/s']) }

      context "adds a single string" do
        hookup { topic.add 'rubinius/rubinius' }
        asserts(:list).equals ['s/s', 'rubinius/rubinius']
      end

      context "adds an array of strings" do
        hookup { topic.add ['rubinius/rubinius', 'vim-scripts/test.vim'] }
        asserts(:list).equals ['s/s', 'rubinius/rubinius', 'vim-scripts/test.vim']
      end
    end
  end

  context "#remove" do
    setup { Contributions::RepositoryList.new(['s/s', 's/ss', 'o/other']) }

    context "selectively removes a single repo" do
      hookup { topic.remove 's/s' }
      asserts(:list).equals ['s/ss', 'o/other']
    end

    context "selectively removes an array of repos" do
      hookup { topic.remove ['s/s', 's/ss'] }
      asserts(:list).equals ['o/other']
    end
  end

  context "#only completely replaces the list" do
    setup { Contributions::RepositoryList.new(['s/s', 's/ss', 'o/other']) }

    context "when given a single repo" do
      hookup { topic.only 'a/a' }
      asserts(:list).equals ['a/a']
    end

    context "when given an array" do
      hookup { topic.only ['a/a', 'b/b'] }
      asserts(:list).equals ['a/a', 'b/b']
    end
  end

  context "#key_value_pairs splits into key value pairs" do
    setup { Contributions::RepositoryList.new(['s/s', 's/ss', 'o/other']) }
    asserts(:key_value_pairs).equals [{:username => 's', :repository => 's'},
                                      {:username => 's', :repository => 'ss'},
                                      {:username => 'o', :repository => 'other'}]
  end

end



