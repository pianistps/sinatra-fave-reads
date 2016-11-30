class UsersController < ApplicationController

  get '/users/new' do
    erb :'/users/new'
  end

  post '/signup' do
    @user = User.create(params)
    redirect '/'
  end
end
