class CreateLocantos < ActiveRecord::Migration
  def change
    create_table :locantos do |t|
      t.string :site
      t.text :title
      t.text :body
      t.string :image
      t.text :number

      t.timestamps null: false
    end
  end
end
