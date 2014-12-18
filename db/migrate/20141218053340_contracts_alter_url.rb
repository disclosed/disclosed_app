class ContractsAlterUrl < ActiveRecord::Migration
  def change
    change_column :contracts, :url, :text
  end
end
