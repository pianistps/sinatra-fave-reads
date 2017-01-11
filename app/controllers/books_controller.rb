require './config/environment'

class BooksController < ApplicationController

  get '/books' do
    if is_logged_in?
      @user = User.find_by_id(current_user.id)
      erb :'/books/index'
    else
      redirect '/'
    end
  end

  get '/books/new' do
    if is_logged_in?
        erb :'/books/new'
    else
      redirect '/'
    end
  end

  post '/books' do
    @book = current_user.books.build(title: params[:title], summary: params[:summary])
    @book.author = Author.find_or_create_by(name: params[:author][:name])
    if @book.save
      flash[:message] = "Successfully created book!" #works
      redirect '/books'
    else
      redirect '/books/new'
    end
  end

  get '/books/:id' do
    if is_logged_in?
      @book = Book.find_by_id(params[:id])
      if @book
        if @book.user_id == current_user.id
          erb :'books/show'
        else
          flash[:message] = "This isn't your book"
          redirect '/books'
        end
      else
        flash[:message] = "No such Book exists!"
        redirect '/books'
      end
    else
      redirect '/'
    end
  end

  get '/books/:id/edit' do
    if is_logged_in?
      @book = Book.find_by_id(params[:id])
      @user = User.find_by_id(current_user.id)
      if @book.user == current_user
        erb :'/books/edit'
      else
        redirect '/books'
      end
    else
      redirect '/'
    end
  end

  post '/books/:id' do
    if is_logged_in?
      @book = Book.find_by_id(params[:id])
      @user = User.find_by_id(current_user.id)
      if current_user.books.include?(@book)
        @book.update(title: params[:title], summary: params[:summary], author_id: params[:author][:name])
        flash[:message] = "Successfully edited book!" #works
        redirect "/books/#{@book.id}"
      else
        redirect '/books'
      end
    else
      redirect '/'
    end
  end

  post '/books/:id/delete' do
    if is_logged_in?
      @book = Book.find_by_id(params[:id])
      if current_user.books.include?(@book)
        @book.delete
        flash[:message] = "Successfully deleted book!" #working
        redirect '/books'
      else
        redirect '/books'
      end
    else
      redirect '/'
    end
  end
end
