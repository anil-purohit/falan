class Book < ActiveRecord::Base
  def self.to_hash(book)
    book_info = {}
    book_info[:book_id] = book[:id]
    book_info[:title] = book[:title]
    book_info[:author] = book[:author]
    book_info[:publication]= book[:publication]
    book_info[:tags] = book[:tags]
    book_info[:isbn] = book[:isbn]
    book_info[:url] = book[:url]
    book_info
  end
end
