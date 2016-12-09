require './config/environment'

class AuthorsController < ApplicationController

  get '/authors' do
    if is_logged_in?
      @user = User.find_by_id(current_user.id)
      @authors = @user.authors
      erb :'/authors/index'
    else
      redirect '/'
    end
  end

  get '/authors/:id' do
    if is_logged_in?
      @author = Author.find_by_id(params[:id])
      erb :'/authors/show'
    else
      redirect '/'
    end
  end

end
