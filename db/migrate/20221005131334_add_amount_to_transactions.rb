class AddAmountToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :amount, :integer, default: 1
  end
end
