# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :authorized?, except: %i[create]
  before_action :set_customer, only: %i[show update destroy appointments]

  def index
    render json: Customer.all
  end

  def show
    render json: @customer
  end

  def new
    @customer = Customer.new
  end

  def create
    if @customer
      render json: {
               status: {
                 message: 'Customer already exists.'
               }
             },
             status: :unprocessable_entity
    else
      @new_customer = Customer.new(
        email: params[:email],
        first_name: params[:first_name],
        last_name: params[:last_name],
        first_name_phonetic: params[:first_name_phonetic],
        last_name_phonetic: params[:last_name_phonetic],
        tel: params[:tel]
      )

      if @new_customer.save
        render json: {
          status: {
            code: 200,
            message: 'Customer created successfully.'
          },
          customer_details: @new_customer
        }
      else
        render json: {
                 status: {
                   message: "User couldn't be created succesfully. #{@new_customer.errors.full_messages.to_sentence}"
                 }
               },
               status: :unprocessable_entity
      end
    end
  end

  def update
    if @customer.update(customer_params)
      render json: @customer
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @customer.destroy
      render json: {
        status: {
          code: 200,
          message: 'Customer deleted successfully.'
        }
      }
    else
      render json: {
               status: {
                 message: 'Customer couldn\'t be deleted.'
               }
             },
             status: :unprocessable_entity
    end
  end

  def appointments
    render json: Appointment.where(customer_id: @customer.id)
  end

  private

  def customer_params
    params.require(:customer).permit(:email, :first_name, :last_name, :first_name_phonetic, :last_name_phonetic, :tel)
  end

  def set_customer
    @customer = Customer.find_by_id(params[:id])

    return @customer if @customer

    render json: {
      status: {
        code: 404,
        message: 'Customer not found.'
      }
    }, status: :not_found
  end
end
