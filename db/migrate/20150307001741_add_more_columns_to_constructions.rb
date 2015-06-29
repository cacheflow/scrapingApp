class AddMoreColumnsToConstructions < ActiveRecord::Migration
  def change
    add_column :constructions, :brand, :string
    add_column :constructions, :description, :text
    add_column :constructions, :number, :string 
    add_column :constructions, :price, :string
    add_column :constructions, :location, :string
    add_column :constructions, :image, :string
  end
end
