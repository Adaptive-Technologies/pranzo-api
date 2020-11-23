class CreateVouchers < ActiveRecord::Migration[6.0]
  def change
    create_table :vouchers do |t|
      t.integer :value
      t.boolean :paid

      t.timestamps
    end
  end
end
