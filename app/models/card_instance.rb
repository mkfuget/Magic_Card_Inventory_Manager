require_relative './concerns/slugifiable.rb'

class CardInstance < ActiveRecord::Base
    belongs_to :deck
    belongs_to :card
    belongs_to :user
    include Slugifiable::InstanceMethods
    extend Slugifiable::ClassMethods
  
end