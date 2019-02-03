class AddTextTable < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :texts, id: :uuid do |t|
      t.text :content
      t.timestamps
    end
  end
end
