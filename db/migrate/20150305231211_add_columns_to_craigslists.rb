class AddColumnsToCraigslists < ActiveRecord::Migration
  def change
    add_column :craigslists, :title, :string
    add_column :craigslists, :body, :text
    add_column :craigslists, :image, :string
  end
end
