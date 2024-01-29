class CreateHolidays < ActiveRecord::Migration[7.1]
  def change
    create_table :holidays do |t|
      t.datetime :date

      t.timestamps
    end
  end
end
