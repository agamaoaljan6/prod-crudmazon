class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  validates(:body, presence: true)
  validates(:rating, numericality: { less_than_or_equal_to: 5 }) 
end
