class TextMessage < ApplicationRecord
  validates_presence_of :to_number, :message

  before_create :is_invalid_number?, :set_default_status

  def is_invalid_number?
    raise "The number you provided is invalid." if InvalidNumber.where(number: self.to_number).exists?
  end

  def set_default_status
    self.status = "processing"
  end
end
