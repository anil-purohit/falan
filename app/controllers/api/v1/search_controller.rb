class Api::V1::SearchController < Api::MainController

  def search
    return create_response(400, "Bad Request") if params[:id].to_i <= 0
    user = User.where(:id => params[:id].to_i).first
    return create_response(400, "Bad Request") if (user.nil? || user.status == "inactive")
    friends = user.friends.to_a
    return create_response(200, {}) unless friends.present?

    friend_user_ids = friends.map { |friend| friend.friend_user_id if friend.friend_user_id.present? }.uniq

    friend_user = User.where(:id => friend_user_ids).to_a
    search_response = {}
    friend_user.each do |friend|
      friend_user_id = friend[:id]
      friends_info = build_friends_info(friend)
      search_response[friend_user_id] = friends_info if friends_info[:books].present?
    end
    create_response(200, search_response)
  end

  private

  def build_friends_info(user)
    friend_info = {}
    friend_info[:name] = user[:first_name].to_s + user[:last_name].to_s
    friend_info[:books] = []
    approved_user_books = UserBook.approved_user_books(user[:id])
    return friend_info unless approved_user_books.present?
    friend_info[:lat] = approved_user_books.first[:lat]
    friend_info[:long] = approved_user_books.first[:long]
    books_info = Book.where(:id => approved_user_books.collect(&:book_id)).all
    books_info.each do |book|
      friend_info[:books] << Book.to_hash(book)
    end
    friend_info
  end
end