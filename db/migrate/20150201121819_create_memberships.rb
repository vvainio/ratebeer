class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :beer_club, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :memberships, :beer_clubs
    add_foreign_key :memberships, :users
  end
end
