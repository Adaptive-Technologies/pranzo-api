class AllLegalNameToVendors < ActiveRecord::Migration[7.0]
  def change
    add_column :vendors, :legal_name, :string
  end
end
