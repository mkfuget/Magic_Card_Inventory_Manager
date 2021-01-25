require_relative './concerns/slugifiable.rb'

class User < ActiveRecord::Base
    has_secure_password
    has_many :decks
    has_many :card_instances
    has_many :cards, through: :card_instances
    has_many :sets, through: :card_instances
    include Slugifiable::InstanceMethods
    extend Slugifiable::ClassMethods

    def card_instances_sorted
        self.card_instances.sort_by{|card_instance| card_instance.card.name}
    end

    def decks_sorted
        self.decks.sort_by{|deck| deck.name}
    end

  
end