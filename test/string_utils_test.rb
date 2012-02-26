require 'teststrap'
require 'contributions/string_utils'

context "StringUtils" do
  helper(:string)    { "1b90c5e CONTRIBUTIONS_SEPARATOR 2011-09-13 07:49:43 -0500 CONTRIBUTIONS_SEPARATOR remove mention of deprecated exists from README CONTRIBUTIONS_SEPARATOR  CONTRIBUTIONS_ENDING \n1620141 CONTRIBUTIONS_SEPARATOR 2011-12-16 19:26:58 -0500 CONTRIBUTIONS_SEPARATOR adjust input boxes to be same height as buttons CONTRIBUTIONS_SEPARATOR There was this weird thing happening where the inline submit button on a\nform would be like twice as tall as the text input area (notably on the\nuser_search form, but in a few other places it looked weird).  This\nmakes all those a standard height (the same as the default Twitter\nbutton height). CONTRIBUTIONS_ENDING \n\n" }
  helper(:ending)    { " CONTRIBUTIONS_ENDING " }
  helper(:separator) { " CONTRIBUTIONS_SEPARATOR " }

  context ".split!" do
    context "splits the string in place" do
      setup { Contributions::StringUtils.split!(string, ending) }

      asserts_topic.size 3
    end
  end

  context ".remove_empty throws out any 'blank' arrays" do
    setup { Contributions::StringUtils.remove_empty([['s'], ['', 's'], ['']]) }
    asserts_topic.size 2
  end

  context ".zip_to_hash" do
    context "creates a hash with the first array as the key" do
      setup { Contributions::StringUtils.zip_to_hash([:k, :v, :e], ['key', 'value', 'empty']) }
      asserts_topic.equals Hash[:k => 'key', :v => 'value', :e => 'empty']
    end

    context "creates a hash with the first array as the key and '' for any empty values" do
      setup { Contributions::StringUtils.zip_to_hash([:k, :v, :e], ['key']) }
      asserts_topic.equals Hash[:k => 'key', :v => '', :e => '']
    end
  end

  ## Move this test to StringUtils
  # context ".parse turns a hash of commit info into a useful hash" do
  #   setup do
  #     a = "1b90c5e CONTRIBUTIONS_SEPARATOR 2011-09-13 07:49:43 -0500 CONTRIBUTIONS_SEPARATOR remove mention of deprecated exists from README CONTRIBUTIONS_SEPARATOR  CONTRIBUTIONS_ENDING \n7201941 CONTRIBUTIONS_SEPARATOR 2011-09-13 07:48:53 -0500 CONTRIBUTIONS_SEPARATOR add deprecation warning to exists macro CONTRIBUTIONS_SEPARATOR  CONTRIBUTIONS_ENDING \n1620141 CONTRIBUTIONS_SEPARATOR 2011-12-16 19:26:58 -0500 CONTRIBUTIONS_SEPARATOR adjust input boxes to be same height as buttons CONTRIBUTIONS_SEPARATOR There was this weird thing happening where the inline submit button on a\nform would be like twice as tall as the text input area (notably on the\nuser_search form, but in a few other places it looked weird).  This\nmakes all those a standard height (the same as the default Twitter\nbutton height). CONTRIBUTIONS_ENDING \n\n"
  #     Contributions::Git.parse(a)
  #   end

  #   asserts_topic.equals [{:sha => "1b90c5e",
  #                         :date => "2011-09-13",
  #                         :subject =>  "remove mention of deprecated exists from README",
  #                         :body => ''},
  #                         {:sha => "1620141",
  #                         :date => "2011-12-16",
  #                         :subject => "adjust input boxes to be same height as buttons",
  #                         :body => "There was this weird thing happening where the inline submit button on a\nform would be like twice as tall as the text input area (notably on the\nuser_search form, but in a few other places it looked weird).  This\nmakes all those a standard height (the same as the default Twitter\nbutton height)."}]
  # end

end
