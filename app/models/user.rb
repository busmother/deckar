require 'pry'

class User < ActiveRecord::Base
    has_secure_password
    has_many :decks
    has_many :cards, through: :decks

    validates :email, uniqueness: true
    validates :username, uniqueness: true

    def slug #could be combined with the deck.rb slug methods
        self.username.gsub(" ","-")
    end

    def self.find_by_slug(slug) #could be combined with the deck.rb slug methods
        name = slug.gsub("-"," ")
        User.find_by(username :name)
    end

    # def self.name
    #     @username
    # end

end