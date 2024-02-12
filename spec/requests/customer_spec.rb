# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

require 'pry'

RSpec.describe 'Customers', type: :request do
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

    Appointment.create(
      customer_id: @customer.id,
      date: DateTime.strptime('03/07/2025 4:00:00 PM', '%m/%d/%Y %I:%M:%S %p'),
      length: 15,
      course: 'trial',
      price: 2000
    )
  end

  describe 'GET /customers' do
    before do
      get '/customers', headers: { 'Authorization': @token }
    end

    it 'Returns all customers' do
      customers = JSON.parse(response.body)
      expect(customers.size).to eq(Customer.count)
    end

    it 'Returns status: 200 OK' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /customers/:id' do
    before do
      get "/customers/#{@customer.id}", headers: { 'Authorization': @token }

      @customer_response = JSON.parse(response.body)
    end

    it 'Returns one customer' do
      expect([@customer_response].count).to eq(1)
    end

    it 'Returns status: 200 OK (Customer exists)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns status: 401 Unauthorized (User not signed in)' do
      delete '/logout', headers: { 'Authorization': @token }

      get "/customers/#{@customer.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /customers/:id/appointments' do
    before do
      get "/customers/#{@customer.id}/appointments", headers: { 'Authorization': @token }

      @customer_appointments_response = JSON.parse(response.body)
    end

    it 'Returns one appointment' do
      expect(@customer_appointments_response.count).to eq(1)
    end

    it 'Returns status: 200 OK (Customer has an appointment)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns status: 401 Unauthorized (User not signed in)' do
      delete '/logout', headers: { 'Authorization': @token }

      get "/customers/#{@customer.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /customers' do
    before do
      @initial_customer_count = Customer.count

      @holiday_post_params = {
        "email": 'post_test@rspec.com',
        "first_name": 'Post',
        "last_name": 'Test',
        "first_name_phonetic": 'ポスト',
        "last_name_phonetic": 'テスト',
        "tel": '08087654321'
      }

      post '/customers', params: @holiday_post_params
    end

    it 'Successfully adds a new customer' do
      expect(Customer.count).to eq(@initial_customer_count + 1)
    end

    it 'Returns status: 200 OK (Customer is a new, unique entry)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns status: 422 Unprocessable Content (Customer already exists)' do
      post '/customers', params: @holiday_post_params

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /customers/:id' do
    before do
      patch "/customers/#{@customer.id}", params: { customer: { tel: '07087654321' } },
                                          headers: { 'Authorization': @token }

      @updated_customer = JSON.parse(response.body)
    end

    it 'Returns status: 200 OK (Customer updated successfully)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns the correct phone number (Response tel equals updated tel parameter)' do
      expect(@updated_customer['tel']).to eq('07087654321')
    end
  end

  describe 'DELETE /customers/:id' do
    before do
      customer_to_delete = Customer.create(
        email: 'delete@test.com',
        first_name: 'Delete',
        last_name: 'Me',
        first_name_phonetic: 'デリート',
        last_name_phonetic: 'ミー',
        tel: '07012345678'
      )

      delete "/customers/#{customer_to_delete.id}", headers: { 'Authorization': @token }
    end

    it 'Returns status: 200 OK (Customer successfully deleted)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns status: 404 Not Found (Invalid ID provided)' do
      delete '/customers/-1', headers: { 'Authorization': @token }

      expect(response).to have_http_status(:not_found)
    end
  end

  after(:all) do
    Appointment.delete_all
    Customer.delete_all
  end
end
