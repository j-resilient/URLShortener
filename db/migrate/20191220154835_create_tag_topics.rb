class CreateTagTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_topics do |t|
      t.string :tag_topic, null: false, unique: true
      t.timestamps
    end

    add_index :tag_topics, :tag_topic
  end
end
