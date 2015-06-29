class CreateConstructions < ActiveRecord::Migration
  def change
    create_table :constructions do |t|
      t.string :site

      t.timestamps null: false
    end
  end
end
