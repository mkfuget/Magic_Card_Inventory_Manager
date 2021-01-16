
require_relative './concerns/slugifiable.rb'

class Card < ActiveRecord::Base
    has_many :card_instances
    has_many :decks, through: :card_instances
    belongs_to :sets
    has_many :users, through: :card_instances
    serialize :rules_text, Array
    include Slugifiable::InstanceMethods
    extend Slugifiable::ClassMethods
  
end