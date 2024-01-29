# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

now = DateTime.now
six_months_later = now >> 6

days_variance = (six_months_later - now).to_i

@customer = Customer.find_by(email: 'bobross@iluvpaint.com')

puts 'Creating 10 placeholder appointments:'

10.times do
  random_moment = now + Rational(rand(days_variance * 86400), 86400)

  appointment = Appointment.new(
    customer_id: @customer.id,
    length: [15, 30, 60, 120].sample,
    course: ['trial', 'starter', 'single', 'double'].sample,
    price: [2000, 4000, 8000, 12000].sample,
    date: random_moment.strftime('%m/%d/%Y %I:%M:%S %p')
  )

  appointment.save!

  puts appointment
end

puts '10 appointments created.'