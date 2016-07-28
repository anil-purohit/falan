class Api::V1::RequestsController < Api::MainController

  def create
    return create_response(400, "Bad Request") unless validate_request_params(params)
    user_book = UserBook.where(:book_id => params[:book_id], :user_id => params[:friend_user_id]).first
    return create_response(400, "Bad Request") unless user_book.present?
    request = Request.find_or_initialize_by(:requester_id => params[:requester_id], :user_book_id => user_book.id)
    request.status = params[:status].to_i
    request.save

    create_response(200, "success")
  end

  def validate_request_params(params)
    is_valid_request = params[:book_id].to_i >= 1
    is_valid_request &&= params[:friend_user_id] > 1
    is_valid_request &&= params[:requester_id] > 1
    is_valid_request
  end

  def accept
    book_request = Request.where(:id => params[:request_id].to_i).first
    return create_response(400, "Bad Request") unless book_request.present?
    user_book = book_request.user_book
    return create_response(400, "Book is not with owner") if user_book[:current_owner_id] != user_book[:user_id]

    book_request.status = 2
    user_book.current_owner_id = book_request[:requester_id]
    book_request.save
    user_book.save
    create_response(200, "success")
  end

  def reject
    book_request = Request.where(:id => params[:request_id].to_i).first
    return create_response(400, "Bad Request") unless book_request.present?
    book_request.status = 1
    book_request.save
    create_response(200, "success")
  end

  def get_all
    return create_response(400, "Bad Request") if params[:user_id].to_i <= 1
    user_books = UserBook.where(:user_id => params[:user_id].to_i).to_a

    user_book_ids = user_books.collect(&:id)
    user_books_map = user_books.index_by(&:id)
    book_ids = user_books.collect(&:book_id)

    all_requests = Request.where(:user_book_id => user_book_ids).to_a
    all_requester = all_requests.collect(&:requester_id)
    users_info = User.where(:id => all_requester).index_by(&:id)
    books_info = Book.where(:id => book_ids).index_by(&:id)
    response = []
    all_requests.each do |book_request|
      request_info = {}
      user_book_id = book_request[:user_book_id]
      requester = book_request[:requester_id]

      user_book = user_books_map[user_book_id]
      book_id = user_book[:book_id]
      request_info[:request_id] = book_request[:id]
      request_info[:book_id] = book_id
      request_info[:requester_id] = requester
      request_info[:book_name] = books_info[book_id].title
      user_info = users_info[requester]
      request_info[:requester_name] = "#{user_info.first_name} #{user_info.last_name}"
      response << request_info
    end
    create_response(200, response)
  end
end