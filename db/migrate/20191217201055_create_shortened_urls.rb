class CreateShortenedUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :shortened_urls do |t|
      t.string :short_url
      t.string :long_url
      t.integer :user_id
      t.timestamps
    end

    add_index :shortened_urls, [:user_id, :long_url], unique: true
  end
end
