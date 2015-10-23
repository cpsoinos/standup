class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact
  mount_uploader :photo, PhotoUploader

  scope :personal, -> { where(category: "personal") }
  scope :professional, -> { where(category: "professional") }

end
