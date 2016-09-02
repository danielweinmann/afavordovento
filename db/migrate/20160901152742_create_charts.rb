class CreateCharts < ActiveRecord::Migration[5.0]
  def change
    enable_extension "hstore"
    create_table :charts do |t|
      t.references :user, null: false
      t.text :name, null: false
      t.date :birth_date, null: false
      t.boolean :is_female, null: false, default: true
      t.hstore :birth_chart, null: false
      t.integer :ruling_number, null: false
      t.integer :day_number, null: false
      t.timestamps
    end
  end
end
