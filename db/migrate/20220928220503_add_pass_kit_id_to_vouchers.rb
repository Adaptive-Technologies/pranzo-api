class AddPassKitIdToVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :vouchers, :pass_kit_id, :string, default: nil
  end
end
