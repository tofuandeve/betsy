class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :buyer_email
      t.string :buyer_address
      t.string :buyer_name
      t.string :buyer_card
      t.string :card_expiration
      t.string :cvv
      t.string :zipcode

      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
