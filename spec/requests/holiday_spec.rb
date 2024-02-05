# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

def date_formatter(date)
  DateTime.parse(date).strftime('%Y/%m/%d %I:%M:%S %p')
end

RSpec.describe 'Holidays', type: :request do
  describe 'GET /holidays' do
    before do
      get '/holidays'
    end

    it 'Returns all holidays' do
      holidays = JSON.parse(response.body)
      expect(holidays.size).to eq(Holiday.count)
    end

    it 'Returns status: 200 OK' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /holidays/:id' do
    before do
      @test_date = date_formatter('1990/03/07')

      holiday = Holiday.create(date: @test_date)

      get "/holidays/#{holiday.id}"

      @holiday = JSON.parse(response.body)
      @holiday_date = date_formatter(@holiday['date'])
    end

    it 'Returns one holiday' do
      expect([@holiday].count).to eq(1)
    end

    it 'Returns the correct date (Response date equals created holiday date)' do
      expect(@holiday_date).to eq(@test_date)
    end

    it 'Returns status: 200 OK (Holiday exists)' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /holidays' do
    before do
      post '/holidays', params: { holiday: { date: '1990/03/07' } }

      @holiday = JSON.parse(response.body)
    end

    it 'Returns the correct date (Holiday successfully created)' do
      expect(date_formatter(@holiday['holiday_details']['date'])).to eq(date_formatter('1990/03/07'))
    end

    it 'Returns status: 200 OK (Holiday is a new, unique entry)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns status: 422 Unprocessable Content (Holiday already exists)' do
      first_holiday_formatted = Holiday.first.date.strftime('%Y/%m/%d')
      post '/holidays', params: { holiday: { date: first_holiday_formatted } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /holidays/:id' do
    before do
      @initial_date = '1990/03/07'
      @patched_date = '1992/10/12 12:00:00 AM'

      holiday = Holiday.create(date: @initial_date)

      patch "/holidays/#{holiday.id}", params: { holiday: { date: '1992/10/12 12:00:00 AM' } }

      @holiday = JSON.parse(response.body)
      holiday.reload
    end

    it 'Returns status: 200 OK (Holiday updated successfully)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns the correct date (Response date equals updated holiday parameter)' do
      expect(date_formatter(@holiday['holiday_details']['date'])).to eq(date_formatter(@patched_date))
    end
  end

  describe 'DELETE /holidays/:id' do
    before do
      holiday = Holiday.create(date: '1990/03/07')

      delete "/holidays/#{holiday.id}"

      @holiday = JSON.parse(response.body)
    end

    it 'Returns status: 200 OK (Valid ID provided)' do
      expect(response).to have_http_status(:success)
    end

    it 'Returns status: 404 Not Found (Invalid ID provided)' do
      delete '/holidays/-1'

      expect(response).to have_http_status(:not_found)
    end
  end
end

# rubocop:enable Metrics/BlockLength
