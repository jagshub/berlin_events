class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.text :title
      t.text :subtitle
      t.date :start_date, index: true
      t.date :end_date, index: true
      t.string :url
      t.string :category
      t.references :web_source, foreign_key: true, index: true

      t.timestamps
    end
  end
end
