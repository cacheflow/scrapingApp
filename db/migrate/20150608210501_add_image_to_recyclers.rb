class AddImageToRecyclers < ActiveRecord::Migration
  def change
    add_column :recyclers, :image, :string
  end
end
