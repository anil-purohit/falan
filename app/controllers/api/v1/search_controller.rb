class Api::V1::SearchController < Api::MainController


  def search_books_of_user
    return create_response(400, "Bad Request") if params[:id].to_i < 0
    user = User.where(:id => params[:id].to_i).first
    return create_response(400, "Bad Request") if (user.nil? || user.status == "inactive")

    approved_user_books = UserBook.approved_user_books(user[:id])
    friend_user_ids = approved_user_books.collect(&:current_owner_id).uniq.compact
    users = User.where(:id => friend_user_ids).index_by(&:id)
    book_ids = approved_user_books.collect(&:book_id)
    books_info = Book.where(:id => book_ids).index_by(&:id)

    user_books = {}
    approved_user_books.each do |book|
      exchange_status = book[:exchange_status]
      book_id = book.book_id
      user_books[exchange_status] ||= []
      book_info = Book.to_hash(books_info[book_id])
      current_owner = book[:current_owner_id]
      book_info[:owner] = "#{users[current_owner].first_name} #{users[current_owner].last_name}"
      user_books[exchange_status] << book_info
    end
    create_response(200, user_books)
  end

  def home_page_search
    return create_response(400, "Bad Request") if params[:id].to_i < 0
    user = User.where(:id => params[:id].to_i).first
    return create_response(400, "Bad Request") if (user.nil? || user.status == "inactive")

    user_friend_ids = user.friends.collect(&:friend_user_id)
    user_friend_ids.uniq!
    user_friends_info = User.where(:id => user_friend_ids).index_by(&:id)
    friend_books = []
    user_friends_info.each do |id, friend|
      friend_book_info = {}
      friend_book_info[:friend_id] = id
      friend_book_info[:name] = "#{friend.first_name} #{friend.last_name}"
      friend_book_info[:location] = friend.location
      friend_book_info[:lat] = friend.lat
      friend_book_info[:long] = friend.long
      book_count = friend.user_books.approved.count
      if book_count > 0
        friend_book_info[:book_count] = book_count
        friend_books << friend_book_info
      end
    end
    create_response(200, friend_books)
  end

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