class AddServicesToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :services, :text, array: true, default: []
  end
end
