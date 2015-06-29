class CreateBackpages < ActiveRecord::Migration
  def change
    create_table :backpages do |t|
      t.string :site
      t.string :title
      t.text :body
      t.string :image

      t.timestamps null: false
    end
  end
end
