class CreateAutoMakers < ActiveRecord::Migration
  def change
    create_table :auto_makers do |t|
    	t.string :name, :index => true

    	t.timestamps
    end
  end
end
