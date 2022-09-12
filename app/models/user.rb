class User < ApplicationRecord
  has_many :access_keys
  has_many :text_messages
end
