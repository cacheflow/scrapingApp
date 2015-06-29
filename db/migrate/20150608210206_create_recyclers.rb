class CreateRecyclers < ActiveRecord::Migration
  def change
    create_table :recyclers do |t|
      t.string :title
      t.text :body
      t.text :advertiser

      t.timestamps null: false
    end
  end
end
