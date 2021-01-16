require_relative './concerns/slugifiable.rb'

class User < ActiveRecord::Base
    has_secure_password
    has_many :decks
    has_many :card_instances
    has_many :cards, through: :card_instances
    has_many :sets, through: :card_instances
    include Slugifiable::InstanceMethods
    extend Slugifiable::ClassMethods
  
end