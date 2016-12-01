require_relative "spec_helper"

def app
  ApplicationController
end

describe ApplicationController do
  it "responds with a welcome message" do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("Welcome to Sinatra Fave Reads")
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to book index' do
      params = {
        :name => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include("/books")
    end

    it 'does not let a user sign up without a name' do
      params = {
        :name => "",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :name => "skittles123",
        :email => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :name => "skittles123",
        :email => "skittles@aol.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:name => "skittles123", :email => "skittles@aol.com", :password => "rainbows")
      params = {
        :name => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      session = {}
      session[:id] = user.id
      get '/signup'
      expect(last_response.location).to include('/books')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the books index after login' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      params = {
        :email => "starz@aol.com",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :email => "starz@aol.com",
        :password => "kittens"
      }
      post '/login', params
      session = {}
      session[:id] = user.id
      get '/login'
      expect(last_response.location).to include("/books")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :email => "starz@aol.com",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")

    end
    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /books if user not logged in' do
      get '/books'
      expect(last_response.location).to include("/login")
    end

    it 'does load /books if user is logged in' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")


      visit '/login'

      fill_in(:email, :with => "starz@aol.com")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/books')


    end
  end

  describe 'user show page' do
    it 'shows all a single users books' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      author1 = Author.create(:name => "Tolkien")
      book1 = Book.create(:title => "Lord of The Rings", :summary => "A book about battle of Middle Earth", :user_id => user.id, :author_id => author1.id)
      author2 = Author.create(:name => "JK Rowling")
      book2 = Book.create(:title => "Harry Potter & Sorcerors Stone", :summary => "A magical kid goes to wizarding school", :user_id => user.id, :author_id => author2.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("Lord of The Rings")
      expect(last_response.body).to include("Harry Potter & Sorcerors Stone")

    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the books index if logged in' do
        user1 = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        author1 = Author.create(:name => "Tolkien")
        book1 = Book.create(:title => "Lord of The Rings", :summary => "A book about battle of Middle Earth", :user_id => user1.id, :author_id => author1.id)

        user2 = User.create(:name => "silverstallion", :email => "silver@aol.com", :password => "horses")
        author1 = Author.create(:name => "JK Rowling")
        book2 = Book.create(:title => "Harry Potter & Sorcerors Stone", :summary => "A magical kid goes to wizarding school", :user_id => user2.id, :author_id => author1.id)

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/books"
        expect(page.body).to include(book1.author_id.name)
        expect(page.body).to include(book2.author_id.name)
      end
    end


    context 'logged out' do
      it 'does not let a user view the books index if not logged in' do
        get '/books'
        expect(last_response.location).to include("/login")
      end
    end

  end



  describe 'new action' do
    context 'logged in' do
      it 'lets user view new book form if logged in' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/books/new'
        expect(page.status_code).to eq(200)

      end

      it 'lets user create a book if they are logged in' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/books/new'
        fill_in(:title => "Harry Potter & Sorcerors Stone", :summary => "A magical kid goes to wizarding school")
        click_button 'submit'

        user = User.find_by(:name => "becky567")
        book = Book.find_by(:title => "Harry Potter & Sorcerors Stone")
        expect(book).to be_instance_of(Book)
        expect(book.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create a book from another user' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:name => "silverstallion", :email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/books/new'

        fill_in(:title, :with => "New Book", :summary, :with => "A new thrilling book")
        click_button 'submit'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        book = Book.find_by(:title => "New Book")
        expect(book).to be_instance_of(Book)
        expect(book.user_id).to eq(user.id)
        expect(book.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a book with a blank title' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/books/new'

        fill_in(:title, :with => "", :summary, :with => "This shouldn't work without title")
        click_button 'submit'

        expect(Book.find_by(:title => "")).to eq(nil)
        expect(page.current_path).to eq("/books/new")

      end

      it 'does not let a user create a book with a blank summary' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/books/new'

        fill_in(:title, :with => "Title without summary", :summary, :with => "")
        click_button 'submit'

        expect(Book.find_by(:summary => "")).to eq(nil)
        expect(page.current_path).to eq("/books/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new book form if not logged in' do
        get '/books/new'
        expect(last_response.location).to include("/login")
      end
    end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single book' do

        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book = Book.create(:title => "11.22.63",:summary => "Time traveling to save JFK", :user_id => user.id)

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/books/#{book.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Book")
        expect(page.body).to include(book.title)
        expect(page.body).to include(book.summary)
        expect(page.body).to include("Edit Book")
      end
    end

    context 'logged out' do
      it 'does not let a user view a book' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book = Book.create(:title => "The nightmare on Elm Street", :summary => "about a scary dude", :user_id => user.id)
        get "/books/#{book.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end


  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view book edit form if they are logged in' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book = Book.create(:title => "Harry Potter", :summary => "about a boy with a scar", :user_id => user.id)
        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/books/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(book.title)
        expect(page.body).to include(book.summary)
      end

      it 'does not let a user edit a book they did not create' do
        user1 = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book1 = Book.create(:title => "Les Miserables", :summary => "People die and people love", :user_id => user1.id)

        user2 = User.create(:name => "silverstallion", :email => "silver@aol.com", :password => "horses")
        book2 = Book.create(:title => "Harry Potter", :summary => "about a boy with a scar", :user_id => user2.id)

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        session = {}
        session[:user_id] = user1.id
        visit "/books/#{book2.id}/edit"
        expect(page.current_path).to include('/books')

      end

      it 'lets a user edit their own book if they are logged in' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book = Book.create(:title => "Harry Potter", :summary => "about a boy with a scar", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/books/1/edit'

        fill_in(:summary => "A boy saves the world from Voldy!")

        click_button 'submit'
        expect(Book.find_by(:summary => "A boy saves the world from Voldy!")).to be_instance_of(Book)
        expect(Book.find_by(:summary => "about a boy with a scar")).to eq(nil)

        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a book with blank title' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book = Book.create(::title => "Harry Potter", :summary => "about a boy with a scar", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/books/1/edit'

        fill_in(:title, :with => "")

        click_button 'submit'
        expect(Book.find_by(:title => "Harry Potter")).to be(nil)
        expect(page.current_path).to eq("/books/1/edit")

      end

      it 'does not let a user edit a book with blank summary' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book = Book.create(::title => "Harry Potter", :summary => "about a boy with a scar", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/books/1/edit'

        fill_in(:summary, :with => "")

        click_button 'submit'
        expect(Book.find_by(:summary => "about a boy with a scar")).to be(nil)
        expect(page.current_path).to eq("/books/1/edit")

      end
    end

    context "logged out" do
      it 'does not load let user view book edit form if not logged in' do
        get '/books/1/edit'
        expect(last_response.location).to include("/login")
      end
    end

  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own book if they are logged in' do
        user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book = Book.create(:title => "Harry Potter", :summary => "A booy with a scar", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit 'books/1'
        click_button "Delete book"
        expect(page.status_code).to eq(200)
        expect(Book.find_by(:title => "Harry Potter")).to eq(nil)
      end

      it 'does not let a user delete a tweet they did not create' do
        user1 = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
        book1 = Book.create(:title => "Harry Potter", :summary => "A boy with a scar", :user_id => user1.id)

        user2 = User.create(:name => "silverstallion", :email => "silver@aol.com", :password => "horses")
        book2 = Book.create(:title => "Harry Potter is alive", :summary => "A grown up HP", :user_id => user2.id)

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "books/#{book2.id}"
        click_button "Delete Book"
        expect(page.status_code).to eq(200)
        expect(Book.find_by(:title => "Harry Potter is alive")).to be_instance_of(Book)
        expect(page.current_path).to include('/books')
      end

    end

    context "logged out" do
      it 'does not load let user delete a tweet if not logged in' do
        book = Book.create(:title => "Lord of the Rings", :summary => "returning a ring to mount doom", :user_id => 1)
        visit '/books/1'
        expect(page.current_path).to eq("/login")
      end
    end

  end


end
