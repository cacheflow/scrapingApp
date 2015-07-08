class AddPagesToLocanto < ActiveRecord::Migration
  def change
    add_column :locantos, :pages, :integer
  end
end
