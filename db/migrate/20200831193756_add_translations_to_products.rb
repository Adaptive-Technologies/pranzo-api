class AddTranslationsToProducts < ActiveRecord::Migration[6.0]
  def change
    Product.create_translation_table!(
      {
        subtitle: {
          type: :text,
          null: false
        }
      }
    )
  end
end
