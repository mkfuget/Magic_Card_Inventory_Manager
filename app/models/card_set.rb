require_relative './concerns/slugifiable.rb'


class CardSet < ActiveRecord::Base
    has_many :cards
    include Slugifiable::InstanceMethods
    extend Slugifiable::ClassMethods
  
end