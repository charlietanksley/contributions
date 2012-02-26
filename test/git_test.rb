require 'teststrap'
require 'contributions/git'

context "Contributions::Git" do
  context ".contributions" do
    context 'determines all the user\'s contributions' do
      setup { Contributions::Git.contributions('Charlie Tanksley', 'thumblemonks/riot') }

      asserts_topic.size 6
    end
  end

  context ".clone creates a clone and runs the block you pass it" do
    helper(:command) { "git log --author='Charlie Tanksley' --format='%h %ci %s %b' --no-color" }
    setup do
      Contributions::Git.clone('thumblemonks/riot') { IO.popen(command) { |io| io.readlines } }
    end

    asserts_topic.size 6
  end

  context ".log_format" do
    setup { Contributions::Git.log_format }

    asserts_topic.equals "%h CONTRIBUTIONS_SEPARATOR %ci CONTRIBUTIONS_SEPARATOR %s CONTRIBUTIONS_SEPARATOR %b CONTRIBUTIONS_ENDING "
  end

end
