class CreateBook < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :summary
      t.integer :user_id
      t.integer :author_id
    end
  end
end
