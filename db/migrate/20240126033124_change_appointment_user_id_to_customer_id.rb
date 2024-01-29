class ChangeAppointmentUserIdToCustomerId < ActiveRecord::Migration[7.1]
  def change
    remove_column :appointments, :user_id
    add_column :appointments, :customer_id, :integer, null: false
    add_foreign_key :appointments, :users, column: :customer_id
  end
end
