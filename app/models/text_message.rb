class TextMessage < ApplicationRecord
  belongs_to :user

  validates_presence_of :to_number, :message, :user_id

  before_create :set_default_status

  validate :is_invalid_number?, on: :create

  STATUS_PROCESSING = "processing"
  STATUS_INVALID = "invalid"
  STATUS_FAILED = "failed"
  STATUS_DELIVERED = "delivered"

  def is_invalid_number?
    self.errors.add(:to_number, "The number you provided is invalid.") if InvalidNumber.where(number: self.to_number).exists?
  end

  def set_default_status
    self.status = STATUS_PROCESSING
  end
end
