class Api::V1::UserBooksController < Api::MainController

  # Post Request to upload images for a user.
  # Sample post request : {
  #   "user_books": {
  #     "user_id": 1,
  #     "lat": 0,
  #     "long": 0,
  #     "images": [ "base64-encoded image-1", "base64-encoded image-2" ]
  #   }
  # }

  def create
    create_response(400, "Bad Request") unless validate_request_params(params)
    response = {}
    user_books = create_individual_user_book(params[:user_books])
    user_books.each_with_index do |book, index|
      user_book = UserBook.new(book)
      result = user_book.save!
      response[index] = user_book.url.url if result
    end
    create_response(200, response)
  end

  def delete
    return create_response(400, "Bad Request") if (params[:user_id] <=0 || params[:book_id] <=0)
    user_book = UserBook.where(:user_id => params[:user_id], :book_id => params[:book_id]).first
    if user_book.present? && user_book[:exchange_status] == 0
      user_book.destroy
      create_response(200, "success.")
    else
      create_response(400, "Book is not with user.")
    end
  end

  def update_status
    create_response(400, "Bad Request") if (params[:user_id] <=0 || params[:book_id] <=0)
    user_book = UserBook.where(:user_id => params[:user_id], :book_id => params[:book_id]).first
    if user_book.present?
      user_book[:exchange_status] = params[:exchange_status]
      user_book[:current_owner_id] = params[:new_user_id].to_i

      return create_response(400, "Bad Request") if (user_book[:exchange_status] == 0 && user_book[:user_id] != user_book[:current_owner_id])

      user_book.save
      create_response(200, "success")
    else
      create_response(400, "Book is not with user.")
    end
  end

  def create_individual_user_book(user_book_params)
    user_books = []
    user_book_params[:images].each do |image|
      user_book = {}
      user_book[:user_id] = user_book_params[:user_id]
      user_book[:lat] = user_book_params[:lat]
      user_book[:long] = user_book_params[:long]
      user_book[:current_owner_id] = user_book_params[:user_id]
      user_book[:url] = convert_data_uri_to_upload(user_book_params[:user_id], image)[:image]
      user_books << user_book
    end
    user_books
  end


  private

  def split_base64(uri_str)
    uri = {}
    if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
      uri[:type] = $1 # "image/gif"
      uri[:encoder] = $2 # "base64"
      uri[:data] = $3 # data string
      uri[:extension] = $1.split('/')[1] # "gif"
    end
    uri
  end

  def convert_data_uri_to_upload(user_id, image)
    result = {}
    if image.try(:match, %r{^data:(.*?);(.*?),(.*)$})
      image_data = split_base64(image)
      image_data_string = image_data[:data]
      image_data_binary = Base64.decode64(image_data_string)

      temp_img_file = Tempfile.new("")
      temp_img_file.binmode
      temp_img_file << image_data_binary
      temp_img_file.rewind

      img_params = {:filename => "#{Time.now.to_i}_#{user_id}_image.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}
      uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)

      result[:image] = uploaded_file
    end
    result
  end

  def validate_request_params(params)
    valid_keys = [:user_id, :lat, :long, :images]
    user_books = params[:user_books]
    is_valid_request = user_books.present?
    valid_keys.each { |key| is_valid_request &= user_books[key].present? }
    is_valid_request && user_books[:user_id].to_i > 0
  end
end
