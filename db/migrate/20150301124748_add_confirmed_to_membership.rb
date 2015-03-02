class AddConfirmedToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :confirmed, :boolean, null: false, default: false

    Membership.reset_column_information

    Membership.all.each do |m|
      m.confirmed = true
      m.save
    end
  end
end
