require 'faker/japanese'
require 'rest-client'

puts 'Setting up seed config:'

Faker::Config.locale = :ja

start_date = Date.today
end_date = start_date + 6.months

time_range = (10..18).to_a

courses = [
  [ 15, 'trial', 2000 ],
  [ 30, 'starter', 4000 ],
  [ 60, 'single', 8000 ],
  [ 120, 'double', 12000 ]
]

puts 'Configuration setup completed.'

puts '----------'

puts 'Creating primary user:'

User.create!(
  email: 'test@test.com',
  password: 'test1234'
)

puts 'Primary user created.'

puts '----------'

puts 'Creating 5 placeholder customers:'

5.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  Customer.create!(
    email: "#{last_name.romaji.downcase}@#{['gmail', 'yahoo', 'hotmail'].sample}.com",
    first_name: first_name,
    last_name: last_name,
    first_name_phonetic: first_name.kana,
    last_name_phonetic: last_name.kana,
    tel: "#{['070', '080'].sample}#{rand(1000..9999)}#{rand(1000..9999)}"
  )
end

puts '5 customers created.'

puts '----------'

puts 'Creating 10 placeholder appointments:'

10.times do
  @customer = Customer.order("RANDOM()").first

  random_date = rand(start_date..end_date)
  random_date_time = DateTime.new(
    random_date.year,
    random_date.month,
    random_date.day,
    time_range.sample
  )

  selected_course = courses.sample

  appointment = Appointment.new(
    customer_id: @customer.id,
    length: selected_course[0],
    course: selected_course[1],
    price: selected_course[2],
    date: random_date_time.strftime('%Y/%m/%d %I:%M:%S %p')
  )

  appointment.save!
end

puts '10 appointments created.'

puts '----------'

puts '1. Fetching Japanese national holidays:'

holidays_response = RestClient.get("https://holidays-jp.github.io/api/v1/#{Date.current.year}/date.json")
holidays_result = JSON.parse(holidays_response)

puts '2. Adding holidays to database:'

holidays_result.keys.each do |holiday|
  Holiday.create!(
    date: DateTime.parse(holiday).strftime('%Y/%m/%d %I:%M:%S %p')
  )
end

puts 'Holidays added.'

puts 'Seeding complete.'

puts '----------'