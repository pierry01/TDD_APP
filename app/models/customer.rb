class Customer < ApplicationRecord
  validates_presence_of :name, :email, :phone, :avatar, :smoker
end
