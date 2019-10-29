class Order < ApplicationRecord
    has_many :order_items
    validates :buyer_email, presence: true, on: :update
    validates :buyer_address, presence: true, on: :update
    validates :buyer_name, presence: true, on: :update
    validates :buyer_card, presence: true, on: :update
    validates :card_expiration, presence: true, on: :update
    validates :cvv, presence: true, on: :update
    validates :zipcode, presence: true, on: :update
end
