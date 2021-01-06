class User < ActiveRecord::Base
    has_secure_password
    has_many :decks
    has_many :card_instances
    has_many :cards, through: :card_instances
    has_many :sets, through: :card_instances

end