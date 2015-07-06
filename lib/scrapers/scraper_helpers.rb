module ScraperHelpers
  # Transform nested data into strings
  # For fields like the description field
  # Example:
  # h = {vendor: "SmartCorp Inc.", description: {main: "something cool", more: "Something interesting"}
  # flatten_to_json(h)
  # {vendor: "SmartCorp Inc.", description: "something cool; Something interesting"}
  def flatten_to_json(attrs)
    attrs.each do |k, attr|
      attrs[k] = attr.values.reject {|val| !val.present?}.join("; ") if attr.is_a? Hash
    end
  end
end
