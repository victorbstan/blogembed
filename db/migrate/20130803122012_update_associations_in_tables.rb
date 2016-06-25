class UpdateAssociationsInTables < ActiveRecord::Migration
  def change
    add_column :blogs, :user_id, :integer
    add_column :posts, :blog_id, :integer
    add_column :settings, :blog_id, :integer

    add_index :posts, :blog_id
    add_index :settings, :blog_id
  end
end
