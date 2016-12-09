class Book < ActiveRecord::Base
 belongs_to :user
 belongs_to :author
 validates :user_id, :title, :summary, :author_id, presence: true
end
