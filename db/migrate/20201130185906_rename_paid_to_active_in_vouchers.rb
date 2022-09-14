class RenamePaidToActiveInVouchers < ActiveRecord::Migration[6.0]
  def change
    rename_column :vouchers, :paid, :active
    change_column :vouchers, :active, :boolean, default: false
  end
end
