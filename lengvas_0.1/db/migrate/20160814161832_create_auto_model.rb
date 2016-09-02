class CreateAutoModel < ActiveRecord::Migration
  def change
    create_table :auto_models do |t|
    	t.references :auto_maker, :index => true
    	t.string :name, :index => true

    	t.timestamps
    end
  end
end
