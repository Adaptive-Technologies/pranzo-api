class AddVatIdToVendors < ActiveRecord::Migration[7.0]
  def change
    add_column :vendors, :vat_id, :string, required: true
  end
end
