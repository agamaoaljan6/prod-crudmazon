FactoryBot.define do
  factory :article do
    title { Faker::Job.title }
    description { Faker::Job.field }
    published_at {Faker::Date.backward(365 * 5)}
    user
  end
  
  factory :invalid_article, parent: :article do 
    title {nil} 
  end
end
