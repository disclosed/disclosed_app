# Extracted from the minitest-focus gem.
# The gem loader is not working properly in rails 4.1
class Minitest::Test    # :nodoc:
  @@filtered_names = [] # :nodoc:

  ##
  # Focus on the next test defined. Cumulative. Equivalent to
  # running with command line arg: -n /test_name|.../
  #
  #   class MyTest < MiniTest::Unit::TestCase
  #     ...
  #     focus
  #     def test_pass; ... end # this one will run
  #     ...
  #   end

  def self.focus
    meta = class << self; self; end

    meta.send :define_method, :method_added do |name|
      @@filtered_names << "#{self}##{name}"
      filter = "/^(#{Regexp.union(@@filtered_names).source})$/"

      index = ARGV.index("-n")
      unless index then
        index = ARGV.size
        ARGV << "-n"
      end

      ARGV[index + 1] = filter

      meta.send :remove_method, :method_added
    end
  end
end
