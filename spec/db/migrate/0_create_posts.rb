class CreatePosts < ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.datetime :created_at
    end
  end
end
