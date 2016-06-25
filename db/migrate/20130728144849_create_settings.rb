class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :disqus_shortname
      t.references :user

      t.timestamps
    end
  end
end
