# Users
User.create!(name:  "Phong Henry",
             email: "phonghenry14@gmail.com",
             password:              "nhiepphong",
             password_confirmation: "nhiepphong",
)

User.create!(name:  "Phong Henry 2",
             email: "phonghenry1412@gmail.com",
             password:              "nhiepphong",
             password_confirmation: "nhiepphong",
)

# Statuses
users = User.order(:created_at).take(6)
10.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.statuses.create!(content: content) }
end

# Following relationships
user1 = User.first
user2 = User.last
user1.follow(user2)
user2.follow(user1)
