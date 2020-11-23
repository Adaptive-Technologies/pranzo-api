class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.datetime :date
      t.references :voucher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
