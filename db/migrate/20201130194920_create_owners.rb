class CreateOwners < ActiveRecord::Migration[6.0]
  def change
    create_table :owners do |t|
      t.references :voucher, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
