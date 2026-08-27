class CreateArticles < ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :slug
      t.string :content
      t.datetime :created_at
    end
  end
end
