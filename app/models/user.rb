class User < ActiveRecord::Base
  validates :email_id, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :on => :create}, :uniqueness => true
  validates :signup_id, :presence => true
  validates :access_token, :presence => true
  enum :status => [:active, :admin, :inactive]
  enum :signup_medium => [:facebook]
  has_many :user_books
  has_many :friends
  after_save :update_facebook_friends

  def self.get_user_names(user_ids)
    users = where(:id => user_id, :status => 1).all.index_by(&:id)
    users.map { |id, user_details| users[id] = "#{user_details.first_name} #{user_details.last_name}" }
  end

  def update_facebook_friends
    facebook_graph = Koala::Facebook::API.new(access_token)
    facebook_friends = facebook_graph.get_connections(signup_id, "friends")
    facebook_friends.map! { |friend| friend["id"] }
    friend_users = User.where(:signup_id => facebook_friends).all
    friend_users.each do |friend|
      Friend.find_or_initialize_by(:user_id => id, :signup_id => signup_id, :friend_user_id => friend.id) do |new_friend|
        new_friend.save
      end
    end
  end
end
