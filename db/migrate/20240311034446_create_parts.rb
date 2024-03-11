class CreateParts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts do |t|
      t.string :name
      t.date :date_of_change
      t.decimal :price
      t.string :store_url
      t.string :tutorial_url
      t.string :note
      t.references :car, null: false, foreign_key: true

      t.timestamps
    end
  end
end
