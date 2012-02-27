require 'teststrap'
require 'contributions'

context "Contributions public api with mocked .new" do
  hookup do
    stub(Contributions::GithubAPI).forks(anything) { ['r/r', 's/s'] }
  end

  setup { Contributions::Contributions.new(:username => 'charlietanksley') }

  context ".new" do
    context "assignments" do
      asserts_topic.assigns :username
      asserts_topic.assigns :repositories
    end

    asserts(:repositories).equals ['r/r', 's/s']
  end

  context ".add will add repositories" do
    context "if given a string" do
      setup { topic.add 'added/added' }
      asserts_topic.includes 'added/added'
    end

    context "if given an array" do
      setup { topic.add ['added/first', 'added/second'] }
      asserts_topic.includes 'added/first'
      asserts_topic.includes 'added/second'
    end
  end

  context ".contributions_as_hash" do
    context "does not reload hash if it already exists" do
      hookup do
        topic.contributions = Hash[:k => 'v']
        dont_allow(topic).load_contributions
      end

      asserts(:contributions_as_hash).equals Hash[:k => 'v']
    end

    context "calls #load_contributions if there aren't any contributions yet" do
      hookup { mock(topic).load_contributions { topic.contributions = Hash[:k => 'v'] } }
      asserts(:contributions_as_hash).equals Hash[:k => 'v']
    end
  end

  context ".only will trade out repositories" do
    context "if given a string" do
      setup { topic.only 'added/added' }
      asserts_topic.includes 'added/added'
      denies_topic.includes 'r/r'
      denies_topic.includes 's/s'
    end

    context "if given an array" do
      setup { topic.only ['added/first', 'added/second'] }
      asserts_topic.includes 'added/first'
      asserts_topic.includes 'added/second'
      denies_topic.includes 'r/r'
      denies_topic.includes 's/s'
    end
  end

  context ".project_names returns an array of project names" do
    asserts(:project_names).equals { ['r', 's'] }
  end

  context ".load_contributions" do
    context "actually calls out to get the contributions for each fork" do
      hookup do
        mock(Contributions::Git).contributions('Charlie Tanksley', 'r/r') { Hash[:sha => 1] }
        mock(Contributions::Git).contributions('Charlie Tanksley', 's/s') { Hash[:sha => 2] }
      end

      denies(:load_contributions).nil
    end

    context "returns a hash with repository names as keys" do   
      hookup do
        stub(Contributions::Git).contributions('Charlie Tanksley', 'r/r') { Hash[:sha => 1] }
        stub(Contributions::Git).contributions('Charlie Tanksley', 's/s') { Hash[:sha => 2] }
      end                                                       

      asserts(:load_contributions).equals Hash['r/r' => Hash[:sha => 1], 's/s' => Hash[:sha => 2]]
    end

    context "stashes the results in an instance variable" do
      hookup do
        stub(Contributions::Git).contributions('Charlie Tanksley', 'r/r') { Hash[:sha => 1] }
        stub(Contributions::Git).contributions('Charlie Tanksley', 's/s') { Hash[:sha => 2] }
        topic.load_contributions
      end                                                       

      asserts(:contributions).equals Hash['r/r' => Hash[:sha => 1], 's/s' => Hash[:sha => 2]]
    end
  end

  context ".remove will drop repositories" do
    context "if given a string" do
      setup { topic.remove 'r/r' }
      denies_topic.includes 'added/added'
    end

    context "if given an array" do
      setup { topic.remove ['r/r', 's/s'] }
      denies_topic.includes 'r/r'
      denies_topic.includes 's/s'
    end
  end
end
