# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# To run your seeds, do:
# rails db:seed


NUM_PRODUCTS = 0
NUM_USERS = 0
PASSWORD = "supersecret"

# destroy will run callbacks
# delete will avoid callbacks


# should be in order

Review.destroy_all 
Product.destroy_all
User.destroy_all

super_user = User.create(
  first_name: "Jon",
  last_name: "Snow",
  email: "js@winterfell.gov",
  password: PASSWORD
)

NUM_USERS.times do
  first_name =  Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
    password: PASSWORD
  )
end
users = User.all

NUM_PRODUCTS.times do
  created_at = Faker::Date.backward(365 * 5)
  p = Product.create(
    # Faker is a ruby module. We access classes
    # or other modules inside of it with ::.
    # Here, Hacker is a class inside of the
    # Faker module
    title: Faker::Hacker.say_something_smart,
    description: Faker::ChuckNorris.fact,
    created_at: created_at,
    updated_at: created_at,
    user: users.sample
  )

  if p.valid?
    p.reviews = rand(0..15).times.map do
      Review.new(
        body: Faker::GreekPhilosophers.quote,
        rating: rand(0..5),
        user: users.sample
      )
    end
  end
end

products = Product.all
reviews = Review.all

puts Cowsay.say("Generated #{products.count} products", :frogs)
puts Cowsay.say("Generated #{reviews.count} reviews", :tux)
puts Cowsay.say("Generated #{users.count} user", :stegosaurus)

puts "Login with #{super_user.email} and password: #{PASSWORD}"
