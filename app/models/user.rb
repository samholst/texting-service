class User < ApplicationRecord
  has_many :access_keys
end
