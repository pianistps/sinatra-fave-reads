require './config/environment'

class UsersController < ApplicationController

  get '/signup' do
    if is_logged_in?
      redirect '/books'
    else
      erb :'/users/new'
    end
  end

  post '/signup' do
    @user = User.new(params)
    if @user.save
      session[:user_id] = @user.id
      redirect '/books'
    else
      redirect '/signup'
    end
  end

  get '/login' do

  end
end
