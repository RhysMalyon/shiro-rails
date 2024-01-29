# frozen_string_literal: true

class ChangeAppointmentDateToDatetime < ActiveRecord::Migration[7.1]
  def change
    remove_column :appointments, :date
    add_column :appointments, :date, :datetime, default: nil
  end
end
