require './config/environment'

class UsersController < ApplicationController

  get '/signup' do
    erb :'/users/new'
  end

  post '/signup' do
    @user = User.new(params)
    if @user.save
      redirect '/books'
    else
      redirect '/signup'
    end
  end
end
