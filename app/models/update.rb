class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact
  mount_uploader :photo, PhotoUploader

end
