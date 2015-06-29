class AddSiteToRecyclers < ActiveRecord::Migration
  def change
    add_column :recyclers, :site, :string
  end
end
