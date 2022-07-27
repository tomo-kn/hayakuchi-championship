class Practice < ApplicationRecord
  mount_uploader :voice, AudioUploader
  belongs_to :user
end
