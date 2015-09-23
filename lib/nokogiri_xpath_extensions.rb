class NokogiriXpathExtensions
  # Return a node if the text content of it and all its children matches
  # the regular expression (case insensitive).
  # Usage:
  #   node.xpath('.//title[regex(., "\w+")]', NokogiriXpathExtensions.new)
  def regex node_set, regex
    node_set.find_all {|n| n.text.match /#{regex}/i}
  end
end
