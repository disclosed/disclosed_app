class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string     :url
      t.string     :vendor_name
      t.string     :reference_number
      t.date       :start_date
      t.date       :end_date
      t.date       :effective_date
      t.integer    :value
      t.text       :description
      t.text       :comments
      t.references :agency

      t.timestamps
    end
  end
end

