class InvalidNumber < ApplicationRecord
  validates_presence_of :number

  STATUS = "invalid"
end
