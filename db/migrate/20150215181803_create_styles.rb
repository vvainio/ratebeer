class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end

    # Create existing styles
    ['Weizen', 'Lager', 'Pale ale', 'IPA', 'Porter'].each do |style|
      Style.create(name: style, description: "Description of #{style}")
    end

    rename_column :beers, :style, :old_style
    add_column :beers, :style_id, :integer

    Beer.reset_column_information

    # Update all existing beer style relations to corresponding style
    # or to the first style if style is nil
    Beer.all.each do |beer|
      style = Style.find_by(name: beer.old_style) || Style.first
      beer.update_attribute(:style_id, style.id)
    end

    remove_column :beers, :old_style
  end
end
