class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :email, null: false, default: ''
      t.string :first_name, default: nil
      t.string :last_name, default: nil
      t.string :first_name_phonetic, default: nil
      t.string :last_name_phonetic, default: nil
      t.string :tel, default: nil

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps
    end
  end
end
