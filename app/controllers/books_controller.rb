class BooksController < ApplicationController
  before_action :authenticate_user!

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @book_new = Book.new
  end

  def index
    @books = Book.all
    @book = Book.new

    respond_to do |format|
      format.html
      format.csv do |csv|
        send_users_csv(@books)
      end
    end
  end

  def send_users_csv(books)
    csv_data = CSV.generate do |csv|
      header = %w(ID 登録日 投稿者 タイトル)
      csv << header
      books.each do |book|
        values = [book.id, book.created_at, book.user.name, book.title]
        csv << values
      end
    end
    send_data(csv_data, filename: '本一覧情報')
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    unless @book.save
      @books = Book.all
      render 'index'
    end
  end

  def edit
      @book = Book.find(params[:id])
    if
      @book.user_id == current_user.id
      render action: :edit
    else
      redirect_to books_path
    end
  end



  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      flash.now[:alert] = 'error'
      render "edit"
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, { images: [] })
  end

end
