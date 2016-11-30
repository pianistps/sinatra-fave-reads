class Book < ActiveRecord::Base
 belongs_to :user
 belongs_to :author
 validates_presence_of :title
 validates_presence_of :summary
end
