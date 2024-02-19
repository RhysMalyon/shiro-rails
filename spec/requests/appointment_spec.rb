# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

RSpec.describe 'Appointments', type: :request do
  before(:all) do
    @admin_user = User.create(email: 'test@rspec.com', password: 'ilovetesting')

    post '/login', params: { user: { email: @admin_user.email, password: @admin_user.password } }
    @token = response.headers['authorization']

    Customer.create(
      email: 'test@rspec.com',
      first_name: 'Ronald',
      last_name: 'Spec',
      first_name_phonetic: 'ロナルド',
      last_name_phonetic: 'スペック',
      tel: '07012345678'
    )

    @customer = Customer.last

    courses = [
      [15, 'trial', 2000],
      [30, 'starter', 4000],
      [60, 'single', 8000],
      [120, 'double', 12_000]
    ]

    start_date = Date.today
    end_date = start_date + 6.months

    time_range = (10..18).to_a

    5.times do
      random_date = rand(start_date..end_date)
      random_date_time = DateTime.new(
        random_date.year,
        random_date.month,
        random_date.day,
        time_range.sample
      )

      selected_course = courses.sample

      Appointment.create(
        customer_id: @customer.id,
        length: selected_course[0],
        course: selected_course[1],
        price: selected_course[2],
        date: random_date_time.strftime('%Y/%m/%d %I:%M:%S %p')
      )
    end

    @first_appointment = Appointment.first
  end

  describe 'GET /appointments' do
    before do
      get '/appointments', headers: { 'Authorization': @token }
    end

    it 'Returns all appointments' do
      appointments = JSON.parse(response.body)
      expect(appointments.size).to eq(Appointment.count)
    end

    it 'Returns status: 200 OK' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /appointments/:id' do
    before do
      get "/appointments/#{@first_appointment.id}", headers: { 'Authorization': @token }

      @appointment_response = JSON.parse(response.body)
    end

    it 'Returns one appointment' do
      expect([@appointment_response].count).to eq(1)
    end

    it 'Returns status: 200 OK (Appointment exists)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns status: 401 Unauthorized (User not signed in)' do
      delete '/logout', headers: { 'Authorization': @token }

      get "/appointments/#{@first_appointment.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /appointments/times' do
    before do
      get '/appointments/times'

      @appointment_times_response = JSON.parse(response.body)
    end

    it 'Returns same amount of results as appointments' do
      expect(@appointment_times_response.count).to eq(Appointment.count)
    end

    it 'Returns the correct data structure' do
      expect(@appointment_times_response[0]).to have_key('date')
      expect(@appointment_times_response[0]['date']).to be_a String

      expect(@appointment_times_response[0]).to have_key('length')
      expect(@appointment_times_response[0]['length']).to be_a Integer
    end

    it 'Returns status: 200 OK (Appointment exists)' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /appointments' do
    before do
      @initial_appointment_count = Appointment.count

      @appointment_post_params = {
        customer: {
          email: 'test@rspec.com',
          first_name: 'Ronald',
          last_name: 'Spec',
          first_name_phonetic: 'ロナルド',
          last_name_phonetic: 'スペック',
          tel: '07012345678'
        },
        date: '02/16/2024 4:00:00 PM',
        length: '60',
        course: 'double',
        price: 8000
      }

      post '/appointments', params: @appointment_post_params
    end

    it 'Successfully adds a new appointment' do
      expect(Appointment.count).to eq(@initial_appointment_count + 1)
    end

    it 'Returns status: 200 OK (Appointment is a new, unique entry)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns status: 422 Unprocessable Content (Appointment already exists)' do
      post '/appointments', params: @appointment_post_params

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /appointments/:id' do
    before do
      params = {
        appointment: {
          date: '05/16/2024 3:30:00 PM',
          length: '30',
          course: 'single',
          price: 4000
        }
      }

      patch "/appointments/#{@first_appointment.id}", params:, headers: { 'Authorization': @token }

      @updated_appointment = JSON.parse(response.body)
    end

    it 'Returns status: 200 OK (Appointment updated successfully)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns the correct phone number (Response course equals updated course parameter)' do
      expect(@updated_appointment['course']).to eq('single')
    end
  end

  describe 'DELETE /appointments/:id' do
    before do
      appointment_to_delete = Appointment.create(
        customer_id: @customer.id,
        date: DateTime.strptime('03/07/2025 4:00:00 PM', '%m/%d/%Y %I:%M:%S %p'),
        length: 15,
        course: 'trial',
        price: 2000
      )

      delete "/appointments/#{appointment_to_delete.id}", headers: { 'Authorization': @token }
    end

    it 'Returns status: 200 OK (Appointment successfully deleted)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns status: 404 Not Found (Invalid ID provided)' do
      delete '/appointments/-1', headers: { 'Authorization': @token }

      expect(response).to have_http_status(:not_found)
    end
  end

  after(:all) do
    Appointment.delete_all
    Customer.delete_all
  end
end

# rubocop:enable Metrics/BlockLength
