class User < ActiveRecord::Base
    has_secure_password
    has_many :decks
    has_many :cards, through: :decks

    validates :email, presence: true
    validates :email, length: {minimum: 1}
    validates :email, uniqueness: true
    validates :username, presence: true
    validates :username, length: {minimum: 1}
    validates :username, uniqueness: true
    validates :password, presence: true
    validates :password, length: {minimum: 1}


    validates_presence_of :username, :email, :password
    validates_uniqueness_of :username, :email
    
    def slug
        self.username.gsub(" ","-")
    end

    def self.find_by_slug(slug)
        name = slug.gsub("-"," ")
        User.find_by(username :name)
    end

end