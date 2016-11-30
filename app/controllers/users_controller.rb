class UsersController < ApplicationController

  get '/users/new' do
    erb :'/users/new'
  end

  post '/signup' do
    @user = User.new(params)
    if @user.save
      redirect '/books'
    else
      redirect '/'
    end
  end
end
