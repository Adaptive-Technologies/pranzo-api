class AddHonoredByToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :honored_by, :integer, default: nil
  end
end
