class AddRawContractPeriodToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :raw_contract_period, :string
  end
end
