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

end
