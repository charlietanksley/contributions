module Contributions
  class StringUtils
      
    # Internal: Read a long string of commit data and turn it into a
    # hash.
    #
    # string - a string of commit data.
    #
    # Returns a Hash.
    def self.parse(string, separator, ending)
      s = string.dup
      array = string.split()
      small_arrays = array.map { |e| e.split(separator).map { |l| l.strip } }
      small_arrays.delete_if { |a| a[0] == "" and a[1] == nil }
      small_arrays.map! { |a| [:sha, :date, :subject, :body].zip a }
      small_arrays




      # results = []
      # s = string.dup
      # s.gsub!(/(\d{4}-\d{2}-\d{2})/) { |f| " BREAK " + f }
      # s = s.split(" BREAK ")
      # s.delete_if { |l| l.empty? }
      # s.each do |line|
      #   m = /(?<date>\d{4}-\d{2}-\d{2})/.match line
      #   results.push m["date"]
      # end

      # results
    end

    # Public: Split the string on the give separator.
    #
    # separator - the character(s) on which to split the string.
    #
    # Returns a modified version of the string.
    def self.split!(string, separator)
      string.split(separator)
    end

    # Internal: Remove any empty arrays after a split.
    #
    # array - an array of Strings.
    #
    # Returns an Array of Strings (modified)
    def self.remove_empty(array)
      array.delete_if { |a| a[0].empty? and a[1].nil? }
    end
  end
end
