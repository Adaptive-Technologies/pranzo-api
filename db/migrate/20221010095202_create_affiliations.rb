class CreateAffiliations < ActiveRecord::Migration[7.0]
  def change
    create_table :affiliations do |t|
      t.references :vendor, null: false, foreign_key: true
      t.references :affiliate, null: false, foreign_key: true, foreign_key: { to_table: :vendors }

      t.timestamps
    end
  end
end
