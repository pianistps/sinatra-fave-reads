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

end
