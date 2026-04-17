class User < ApplicationRecord
  has_many :resumes, dependent: :destroy
end
