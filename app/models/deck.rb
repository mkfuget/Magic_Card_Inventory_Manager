require_relative './concerns/slugifiable.rb'

class Deck < ActiveRecord::Base
    has_many :card_instances
    has_many :cards, through: :card_instances
    has_many :sets, through: :cards
    belongs_to :user
    include Slugifiable::InstanceMethods
    extend Slugifiable::ClassMethods
  
end