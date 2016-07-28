json.array!(@admin_books) do |admin_book|
  json.extract! admin_book, :id
  json.url admin_book_url(admin_book, :format => :json)
end
