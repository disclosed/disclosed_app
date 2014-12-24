class Contract < ActiveRecord::Base
  belongs_to :agency
  belongs_to :vendor

  validates :url,            presence: true
  validates :agency,         presence: true

  before_save :parse_start_date_end_date

  scope :vendor_name, -> (vendor) do
    return none if vendor.blank?
    where("vendor_name ILIKE ?", "#{vendor}%") 
  end

  scope :effective_date, -> (effective_date) do
   return none if effective_date.blank?
   where effective_date: effective_date 
  end

  scope :description, -> (description) do
    return none if description.blank?
    where("description like ?", "%#{description}%")
  end 

  scope :value, -> (value) do 
    return none if description.blank?
    where("value > ?", value)
  end
# spending per vendor per year per all agencies
  def self.spending_per_vendor(vendor)
    vendor_name = ActiveRecord::Base.sanitize(vendor + "%")
    find_by_sql("SELECT SUM(value) AS total, EXTRACT(year FROM effective_date) AS year FROM contracts WHERE vendor_name ILIKE #{vendor_name} GROUP BY year ORDER BY year")
  end
# total government spending on all agencies, grouped by year
  def self.total_spending
    find_by_sql("SELECT SUM(value) AS total, EXTRACT(year FROM effective_date) AS year FROM contracts GROUP BY year ORDER BY year")
  end
# total spending per each agency, grouped by year
   def self.spending_per_agency(agency)
    find_by_sql("SELECT SUM(value) AS total, EXTRACT(year FROM effective_date) AS year FROM contracts WHERE agency_id = #{agency} GROUP BY year ORDER BY year")
  end


  def self.create_or_update!(attrs)
    contract = self.find_by(reference_number: attrs[:reference_number])
    if contract
      contract.update_attributes!(attrs)
    else
      contract = Contract.create!(attrs)
    end
    contract
  end
  
  def self.to_csv(contracts)
    CSV.generate do |csv|
      csv << column_names
      contracts.each do |contract|
        csv << contract.attributes.values_at(*column_names)
      end
    end
  end

  protected
  def parse_start_date_end_date
    if self.raw_contract_period_changed?
      contract_period = ContractPeriodParser.new(self.raw_contract_period)
      contract_period.parse
      self.start_date = contract_period.start_date
      self.end_date = contract_period.end_date
    end
  end
end

