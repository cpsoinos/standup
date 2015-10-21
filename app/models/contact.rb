class Contact < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  has_many :updates
end
