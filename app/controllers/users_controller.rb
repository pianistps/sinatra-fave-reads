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
    #add feature of flash message if dont have field filled out
    @user = User.new(params)
    if @user.save
      session[:user_id] = @user.id
      redirect '/books'
    else
      erb :'/users/new'
    end
  end

  get '/login' do
    if is_logged_in?
      redirect '/books'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(:email => params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/books'
    else
      redirect '/'
    end
  end

  get '/logout' do
    if is_logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end
end
