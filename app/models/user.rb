class User < ActiveRecord::Base
  validates :email_id, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :on => :create}, :uniqueness => true
  validates :signup_id, :presence => true
  validates :access_token, :presence => true
  enum :status => [:active, :admin, :inactive]
  enum :signup_medium => [:facebook]
  has_many :user_books
  has_many :friends

  def self.get_user_names(user_ids)
    users = where(:id => user_id, :status => 1).all.index_by(&:id)
    users.map { |id, user_details|  users[id] = "#{user_details.first_name} #{user_details.last_name}"}
  end
end
