class AddAffiliateNetworkToVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :vouchers, :affiliate_network, :boolean, default: false
  end
end
