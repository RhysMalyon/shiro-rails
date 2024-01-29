class ChangeAppointmentCustomerIdtoUserId < ActiveRecord::Migration[7.1]
  def change
    remove_column :appointments, :customer_id
    add_column :appointments, :user_id, :integer, null: false
    add_foreign_key :appointments, :users, column: :user_id
  end
end
