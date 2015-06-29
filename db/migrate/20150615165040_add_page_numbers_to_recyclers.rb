class AddPageNumbersToRecyclers < ActiveRecord::Migration
  def change
    add_column :recyclers, :pages, :integer
  end
end
