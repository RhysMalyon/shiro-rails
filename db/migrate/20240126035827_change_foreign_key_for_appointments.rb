class ChangeForeignKeyForAppointments < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :appointments, :users, column: :customer_id
    add_foreign_key :appointments, :customers, column: :customer_id
  end
end
