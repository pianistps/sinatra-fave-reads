require './config/environment'

class BooksController < ApplicationController

  get '/books' do
    if is_logged_in?
      erb :'/books/index'
    else
      redirect '/'
    end
  end

end
