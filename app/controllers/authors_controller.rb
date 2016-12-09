require './config/environment'

class AuthorsController < ApplicationController

  get '/authors' do
    if is_logged_in?
      @user = User.find_by_id(current_user.id)
      @authors = @user.authors
      erb :'/authors/index'
    end
  end

  get '/authors/:id' do
    @author = Author.find_by_id(params[:id])
  end
end
