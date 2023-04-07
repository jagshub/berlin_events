class CreateSources < ActiveRecord::Migration[6.1]
  def change
    create_table :web_sources do |t|
      t.string :title
      t.string :base_url
      t.string :url

      t.timestamps
    end
  end
end
