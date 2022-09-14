class Sentence < ApplicationRecord
  has_many :practices, dependent: :destroy
end
