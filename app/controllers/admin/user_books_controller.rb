class Admin::UserBooksController < Admin::MainController
  before_action :set_user_book, :only => [:show, :edit, :update, :destroy]

  def index
    @user_books = UserBook.where(:status => 0).limit(20).all
  end

  def show
  end

  def new
    @user_book = UserBook.new
  end

  def edit
  end

  def create
    @user_book = UserBook.new(admin_user_book_params)

    respond_to do |format|
      if @user_book.save
        format.html { redirect_to @user_book, :notice => 'User book was successfully created.' }
        format.json { render :show, :status => :created, :location => @admin_user_book }
      else
        format.html { render :new }
        format.json { render :json => @user_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    user_book = params[:user_book]
    book = Book.find_by(:id => user_book[:book_id].to_i)
    update_result = false
    if book.nil?
      @user_book.errors.add(:book_id, "Invalid Book Id.")
    else
      existing_user_book = UserBook.where(:user_id => user_book[:user_id], :book_id => book[:id])
      update_status = 1
      if existing_user_book.present?
        update_status = 2
      end
      update_result = @user_book.update(:book_id => user_book[:book_id], :status => update_status)
    end

    respond_to do |format|
      if update_result
        format.html { redirect_to [:admin, @user_book], :notice => 'User book was successfully updated.' }
        format.json { render :show, :status => :ok, :location => @user_book }
      else
        format.html { render :edit }
        format.json { render :json => @user_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_book.destroy
    respond_to do |format|
      format.html { redirect_to admin_user_books_url, :notice => 'User book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_book
    @user_book = UserBook.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_user_book_params
    params.require(:user_book).permit(:user_id, :book_id)
  end
end
