class Customer < ApplicationRecord
  has_many :appointments, foreign_key: :customer_id, dependent: :destroy

  validates :first_name, :last_name, :first_name_phonetic, :last_name_phonetic, :tel, presence: true
  validates :email, presence: true, uniqueness: true
end
