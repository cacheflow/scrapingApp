class AddImageToPennies < ActiveRecord::Migration
  def change
    add_column :pennies, :image, :text
  end
end
