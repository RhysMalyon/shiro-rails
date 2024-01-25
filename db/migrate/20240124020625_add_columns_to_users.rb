class AddColumnsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string, default: nil
    add_column :users, :last_name, :string, default: nil
    add_column :users, :first_name_phonetic, :string, default: nil
    add_column :users, :last_name_phonetic, :string, default: nil
    add_column :users, :tel, :string, default: nil
    add_column :users, :role, :string, null: false
  end
end
