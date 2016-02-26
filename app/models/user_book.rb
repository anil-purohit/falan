class UserBook < ActiveRecord::Base
  belongs_to :user
  mount_uploader :url, ImageUploader
  enum :status => [:not_approved, :approved]
end
