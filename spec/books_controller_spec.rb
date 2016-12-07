require_relative "spec_helper"

def app
  BooksController
end

describe BooksController do

  describe 'books show page' do
    context 'logged in' do
      it 'shows all a single users books' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book1 = Book.create(:title => "Lord of The Rings", :summary => "A book about battle of Middle Earth", :user_id => user.id)
        author2 = Author.create(:name => "JK Rowling")
        book2 = Book.create(:title => "Harry Potter & Sorcerors Stone", :summary => "A magical kid goes to wizarding school", :user_id => user.id)
        get "/books"

        expect(last_response.body).to include("Lord of The Rings")
        expect(last_response.body).to include("Harry Potter & Sorcerors Stone")
      end
    end
  end

end
