class AddPrimaryEmailToVendors < ActiveRecord::Migration[6.0]
  def change
    add_column :vendors, :primary_email, :string
  end
end
