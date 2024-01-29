class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.integer :customer_id, null: false
      t.string :date, default: nil
      t.integer :length, null: false, default: 0
      t.string :course, null: false
      t.integer :price, null: false, default: 0

      t.timestamps
    end
  end
end
