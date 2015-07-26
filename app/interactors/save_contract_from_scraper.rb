class SaveContractFromScraper
  include Interactor

  MANDATORY_ATTRIBUTES = [:url, :agency, :reference_number, :effective_date]

  def call
    attributes = context.attributes
    agency = context.agency
    attributes[:agency_id] = agency.id
    contract = Contract.contract_for(attributes)
    if contract
      contract.attributes = attributes
    else
      contract = Contract.new(attributes)
    end
    update_last_scraped_on(contract)
    update_scrubbing_flag(contract)
    unless meets_mandatory_validations?(contract)
      context.message = "  Can't save contract. Missing mandatory attributes. #{contract.errors.full_messages}. URL: #{contract.url}"
      context.fail!
    end
    contract.save!(validate: false)
    context.contract = contract
  end

  private
  def meets_mandatory_validations?(contract)
    result = true
    MANDATORY_ATTRIBUTES.each do |column|
      result = result && !contract.errors.include?(column)
    end
    result
  end

  def update_scrubbing_flag(contract)
    if !contract.valid? && meets_mandatory_validations?(contract)
      contract.needs_scrubbing = true
    end
  end

  def update_last_scraped_on(contract)
    contract.last_scraped_on = Time.now
  end
end
