require 'pry'

class Card < ActiveRecord::Base
    belongs_to :deck
    has_one :user, through: :deck
    
    validates :front, presence: true
    validates :front, length: {minimum: 1}
    validates :back, presence: true
    validates :back, length: {minimum: 1}

    
end