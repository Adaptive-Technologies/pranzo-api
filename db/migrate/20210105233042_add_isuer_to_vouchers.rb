class AddIsuerToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_reference :vouchers, :issuer, index: true, foreign_key: { to_table: :users }
  end
end
