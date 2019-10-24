class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.float :price
      t.integer :stock
      t.string :status
      t.string :photo_url

      t.timestamps
    end
  end
end
