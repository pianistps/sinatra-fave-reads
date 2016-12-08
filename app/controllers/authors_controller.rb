require './config/environment'

class AuthorsController < ApplicationController

  get '/authors' do
    if is_logged_in?
      erb :'/authors/index'
    end
  end
end
