class CardInstance < ActiveRecord::Base
    belongs_to :deck
    belongs_to :card
    belongs_to :user

end