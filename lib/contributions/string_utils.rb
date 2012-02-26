module Contributions
  class StringUtils
      
    # Public: Read a long string of commit data and turn it into a
    # hash.
    #
    # string    - a string of commit data.
    # separator - the separator between values in an entry.
    # ending    - the separator between entries.
    # keys      - an Array of keys for the final hash.
    #
    # Returns a Hash.
    def self.string_to_hash(string, keys, separator, *ending)
      s = string.dup
      s_as_array = ending.empty? ? [s] : self.split!(s, ending[0])

      s_as_array.map! { |e| self.split!(e, separator) }
      self.remove_empty(s_as_array)

      s_as_array.map! do |e|
        e.map! { |line| line.strip }
        self.zip_to_hash(keys, e)
      end

      s_as_array.map do |e|
        self.short_dates(e)
      end

      # s_as_array.map do |e|
      #   self.zip_to_hash(keys, e)
      # end


      # self.split!(s, ending).each do |e|
      #   self.remove_empty(self.split!(e, separator))
      # end

      # Now we need the zip move, then to a hash, then replace nils with
      # ''

      # s = string.dup
      # array = string.split()
      # small_arrays = array.map { |e| e.split(separator).map { |l| l.strip } }
      # small_arrays.delete_if { |a| a[0] == "" and a[1] == nil }
      # small_arrays.map! { |a| [:sha, :date, :subject, :body].zip a }
      # small_arrays




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
      array.delete_if { |a| self.practically_empty?(a[0]) && a[1].nil? }
    end

    # Internal: Determine whether a string has any content.
    #
    # Examples:
    #
    #    StringUtils.practically_empty?('')
    #    # => true
    #    StringUtils.practically_empty?("\n\n")
    #    # => true
    #    StringUtils.practically_empty?("a\n")
    #    # => false
    #
    # Returns a Boolean.
    def self.practically_empty?(arg)
      if arg.empty?
        return true
      elsif !arg.match /\w/
        return true
      else
        return false
      end
    end

    # Internal: Convert a pair of arrays into a hash with the first as
    # keys.
    #
    # keys   - an Array of keys.
    # values - an Array of values.
    #
    # Returns a Hash.
    def self.zip_to_hash(keys, values)
      value = Hash.new
      zipped = keys.zip values
      zipped.each do |pair|
        value[pair.first] = pair.last || ''
      end

      value
    end

    # Internal: Convert date format to a simpler one.
    #
    # hash - a hash with a :date key
    #
    # Returns a Hash.
    def self.short_dates(hash)
      old_date = hash[:date]
      hash[:date] = old_date.match(/(\d{4}-\d{2}-\d{2})/)[1]

      hash
    end
  end
end
