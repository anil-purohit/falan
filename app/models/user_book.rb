class UserBook < ActiveRecord::Base
  belongs_to :user
  has_many :requests
  mount_uploader :url, ImageUploader
  enum :status => [:not_approved, :approved, :rejected]
  enum :exchange_status => [:with_owner, :with_friend, :requested]
  validates :current_owner_id, :presence => true

  def self.approved_user_books(user_id)
    where(:user_id => user_id, :status => 1).all
  end
end
