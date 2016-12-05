require './config/environment'

class BooksController < ApplicationController

  get '/books' do
    erb :'/books/index'
  end

end
