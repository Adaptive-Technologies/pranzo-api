# frozen_string_literal: true

class AddTranslationsToCategories < ActiveRecord::Migration[6.0]
  def change
    Category.create_translation_table!(
      {
        promo: {
          type: :text,
          null: false
        }
      },
      {
        migrate_data: true,
        remove_source_columns: true
      }
    )
  end
end
