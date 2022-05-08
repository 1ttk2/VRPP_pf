class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :tag_id
      t.text :explanation
      t.string :world_url
      t.string :avatar_url

      t.timestamps
    end
  end
end
