class AddNumberToCraigslist < ActiveRecord::Migration
  def change
    add_column :craigslists, :number, :string
  end
end
