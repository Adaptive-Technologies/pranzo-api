class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :post_code
      t.string :city
      t.string :country
      t.float :latitude
      t.float :longitude
      t.references :vendor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
