class AddConfirmedToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :confirmed, :boolean, null: false, default: false

    Membership.all.each do |m|
      m.update_attribute(:confirmed, true)
      m.save
    end
  end
end
