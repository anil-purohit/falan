class User < ActiveRecord::Base
  validates :email_id, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :on => :create}, :uniqueness => true
  validates :signup_id, :presence => true
  enum :status => [:active, :admin, :inactive]
  enum :signup_medium => [:facebook]
  has_many :books
end
