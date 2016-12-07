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
    @user = User.find_by_id(current_user.id)
    if is_logged_in?
      if current_user.id == @user.id
        erb :'/books/new'
      end
    else
      redirect '/'
    end
  end

  post '/books' do
    @book = Book.new(title: params[:title], summary: params[:summary])
    @book.user_id = current_user.id
    @author = Author.create(name: params[:author][:name])
    @book.author_id = @author.id
    if @book.save
      redirect '/books'
    else
      redirect '/books/new'
    end
  end

  get '/books/:id' do
    if is_logged_in?
      @book = Book.find_by_id(params[:id])
      if @book.user_id == current_user.id
        erb :'books/show'
      else
        redirect '/books'
      end
    else
      redirect '/'
    end
  end

  get '/books/:id/edit' do
    if is_logged_in?
      @book = Book.find_by_id(params[:id])
      if @book.user_id == current_user.id
        erb :'/tweets/edit'
      else
        redirect '/books'
      end
    else
      redirect '/'
    end
  end

end
