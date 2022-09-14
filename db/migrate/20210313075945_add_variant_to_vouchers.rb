class AddVariantToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_column :vouchers, :variant, :integer
  end
end
