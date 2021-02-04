require 'pry'

class Card < ActiveRecord::Base
    belongs_to :deck
    has_one :user, through: :deck
end