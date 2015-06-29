class CreatePennies < ActiveRecord::Migration
  def change
    create_table :pennies do |t|
      t.string :site
      t.string :title
      t.text :body
      t.string :contact

      t.timestamps null: false
    end
  end
end
