class HolidaysController < ApplicationController
  before_action :set_holiday, only: %i[show update destroy]

  def index
    render json: Holiday.all
  end

  def show
    render json: @holiday
  end

  def new
    Holiday.new
  end

  def create
    if @holiday
      render json: {
               status: {
                 message: 'Holiday already exists.'
               }
             },
             status: :unprocessable_entity
    else
      @new_holiday = Holiday.create!(
        date: DateTime.parse(holiday_params.to_s).strftime('%Y/%m/%d %I:%M:%S %p')
      )

      if @new_holiday.save
        render json: {
          status: {
            code: 200,
            message: 'Holiday created successfully.'
          },
          holiday_details: @new_holiday
        }
      else
        render json: {
                 status: {
                   message: "Holiday couldn't be created succesfully. #{@new_holiday.errors.full_messages.to_sentence}"
                 }
               },
               status: :unprocessable_entity
      end
    end
  end

  def update
    if @holiday.update(holiday_params.merge!(date: DateTime.strptime(params[:date], '%Y/%m/%d %I:%M:%S %p')))
      render json: @holiday
    else
      render json: @holiday.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @holiday.destroy
      render json: {
        status: {
          code: 200,
          message: 'Holiday deleted successfully.'
        }
      }
    else
      render json: {
               status: {
                 message: 'Holiday couldn\'t be deleted.'
               }
             },
             status: :unprocessable_entity
    end
  end

  private

  def holiday_params
    params.require(:holiday).permit(:date)
  end

  def set_holiday
    @holiday = Holiday.find_by_id(params[:id])

    return @holiday if @holiday

    render json: {
      status: {
        code: 404,
        message: 'Holiday not found.'
      }
    }, status: :not_found
  end
end
