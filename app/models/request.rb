class Request < ActiveRecord::Base
  belongs_to :user_book
  enum :status => [:requested, :rejected, :accepted]
end
