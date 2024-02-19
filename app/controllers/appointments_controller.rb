# frozen_string_literal: true

class AppointmentsController < ApplicationController
  before_action :authorized?, except: %i[create times]
  before_action :set_appointment, only: %i[show update destroy]

  def index
    render json: Appointment.all
  end

  def show
    render json: @appointment
  end

  def new
    Appointment.new
  end

  def create # rubocop:disable Metrics/PerceivedComplexity
    appointment = Appointment.find_by(date: DateTime.strptime(params[:date], '%m/%d/%Y %I:%M:%S %p'))

    return render json: appointment.errors, status: :unprocessable_entity if appointment

    customer = Customer.find_by(email: params[:customer][:email])

    if customer
      appointment = create_appointment(customer, params)

      if appointment.save
        render json: appointment, status: :created
      else
        render json: appointment.errors, status: :unprocessable_entity
      end
    else
      new_customer = Customer.new(
        email: params[:customer][:email],
        first_name: params[:customer][:first_name],
        last_name: params[:customer][:last_name],
        first_name_phonetic: params[:customer][:first_name_phonetic],
        last_name_phonetic: params[:customer][:last_name_phonetic],
        tel: params[:customer][:tel]
      )

      if new_customer.save
        appointment = create_appointment(new_customer, params)

        if appointment.save
          render json: appointment, status: :created
        else
          render json: appointment.errors, status: :unprocessable_entity
        end
      else
        render json: new_customer
      end
    end
  end

  def update
    if @appointment.update(appointment_params.merge!(date: DateTime.strptime(params[:appointment][:date],
                                                                             '%m/%d/%Y %I:%M:%S %p')))
      render json: @appointment
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @appointment.destroy
      render json: {
        status: {
          code: 200,
          message: 'Appointment deleted successfully.'
        }
      }
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  def times
    appointments = Appointment.all

    appointment_times = appointments.map do |appointment|
      {
        date: appointment.date,
        length: appointment.length
      }
    end

    render json: appointment_times
  end

  private

  def appointment_params
    params.require(:appointment).permit(:date, :length, :course, :price)
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def create_appointment(customer, params)
    Appointment.new(
      customer_id: customer.id,
      date: DateTime.strptime(params[:date], '%m/%d/%Y %I:%M:%S %p'),
      length: params[:length],
      course: params[:course],
      price: params[:price]
    )
  end
end
