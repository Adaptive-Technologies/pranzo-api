class AddOrgIdToVendors < ActiveRecord::Migration[7.0]
  def change
    add_column :vendors, :org_id, :string
  end
end
