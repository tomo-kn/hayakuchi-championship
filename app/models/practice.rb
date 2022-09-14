class Practice < ApplicationRecord
  mount_uploader :voice, AudioUploader
  belongs_to :user
  belongs_to :sentence
end
