class Scrapers::TableMapping
  attr_reader :field, :label

  VALID_FIELDS = [:url, :vendor_name, :reference_number, :raw_contract_period, :effective_date, :value, :description, :comments]

  def initialize(field, label = nil)
    validate_field!(field)
    @field = field
    @label = label || field.to_s.gsub('_', ' ')
  end

  private
  def validate_field!(field)
    raise "Invalid field: #{field}" unless VALID_FIELDS.include? field
  end
end
