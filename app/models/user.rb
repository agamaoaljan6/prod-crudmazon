class User < ApplicationRecord
    has_secure_password
    has_many :articles, dependent: :nullify
    has_many :products, class_name: "Product", dependent: :nullify
    has_many :reviews, class_name: "Review", dependent: :nullify


    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, uniqueness: true, 
    format: { with: VALID_EMAIL_REGEX }

    validates :first_name, :last_name, presence: true

    def full_name
     "#{first_name} #{last_name}".strip
     "#{first_name} #{last_name}".strip.titleize
    end
    
end

