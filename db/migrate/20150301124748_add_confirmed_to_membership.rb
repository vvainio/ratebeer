class AddConfirmedToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :confirmed, :boolean, null: false, default: false
  end
end
