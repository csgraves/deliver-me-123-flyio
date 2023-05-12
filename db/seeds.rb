# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create companies
company1 = Company.create(name: 'Company 1', company_iden: 'C1')
company2 = Company.create(name: 'Company 2', company_iden: 'C2')

# Create branches
branch1 = Branch.create(name: 'Branch 1', branch_iden: 'B1', company: company1)
branch2 = Branch.create(name: 'Branch 2', branch_iden: 'B2', company: company2)

# Create users
user1 = User.create(name: 'John Doe', password: 'password123', role: 'admin', branch: branch1, email: '1@1.com', encrypted_password: 'password123', reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil)
user2 = User.create(name: 'Jane Smith', password: 'password456', role: 'driver', branch: branch2, email: '2@2.com', encrypted_password: 'password456', reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil)
user1.password = 'password123'
user1.password_confirmation = 'password123'
user1.save!
user2.password = 'password456'
user2.password_confirmation = 'password456'
user2.save!

# Create schedules
schedule1 = Schedule.create(start_time: Time.zone.now, end_time: Time.zone.now + 2.hours, branch: branch1, branch_only: true)
schedule2 = Schedule.create(start_time: Time.zone.now, end_time: Time.zone.now + 3.hours, user: user2, user_only: true)

# Create availabilities
availability1 = Availability.create(start_time: Time.zone.now, end_time: Time.zone.now + 4.hours, user: user1)
availability2 = Availability.create(start_time: Time.zone.now, end_time: Time.zone.now + 5.hours, user: user2)

# Create articles
article1 = Article.create(title: 'Article 1', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', author: 'John Doe', date: Date.today)
article2 = Article.create(title: 'Article 2', content: 'Ut et accumsan ipsum. Sed fermentum diam felis, non porttitor nunc.', author: 'Jane Smith', date: Date.yesterday)

# Create deliveries
delivery1 = Delivery.create(deliver: Time.zone.now + 1.hour, leave: Time.zone.now, schedule: schedule1)
delivery2 = Delivery.create(deliver: Time.zone.now + 2.hours, leave: Time.zone.now + 1.hour, schedule: schedule2)
