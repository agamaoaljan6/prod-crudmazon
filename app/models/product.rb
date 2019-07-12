class Product < ApplicationRecord
    # This is where you put validations for your application
    belongs_to :user
    has_many(:reviews, dependent: :destroy) 
    # destroy reviews belong to the product

    validates(
        :title,
        presence: true,
        uniqueness: { case_sensitive: false },
        length: { minimum: 10, maximum: 200 }
      )
    
      validates(
        :description,
        presence: true,
        length: { minimum: 10, maximum: 200 }
      )

      validates(
        :price,
        numericality: {greater_than: 0}
      )

      before_save(:set_default_capitalize)
      before_validation(:set_default_price)
      
      def set_default_price
        self.price ||= 1.0
      end
      
      def set_default_capitalize
        self.title= self.title.capitalize
      end
end
