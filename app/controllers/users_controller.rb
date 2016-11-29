class UsersController < ApplicationController

  get '/users/new' do
    erb :'/users/signup'
  end
end
