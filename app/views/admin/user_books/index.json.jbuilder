json.array!(@user_books) do |admin_user_book|
  json.extract! admin_user_book, :id
  json.url admin_user_book_url(admin_user_book, :format => :json)
end
