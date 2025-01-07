class CreateMieleConfigs < ActiveRecord::Migration
  def change
    create_table :miele_configs do |t|
      t.string :title_oportunities
      t.datetime :start_oportunities
      t.datetime :end_oportunities

      t.timestamps null: false
    end
  end
end
