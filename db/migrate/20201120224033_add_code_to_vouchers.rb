class AddCodeToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_column :vouchers, :code, :string, default: SecureRandom.alphanumeric(5)
  end
end
