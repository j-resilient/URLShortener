# == Schema Information
#
# Table name: taggings
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  shortened_url_id :integer
#  tag_topic_id     :integer
#
# Indexes
#
#  index_taggings_on_shortened_url_id  (shortened_url_id)
#  index_taggings_on_tag_topic_id      (tag_topic_id)
#

class Tagging < ApplicationRecord
    validates :shortened_url_id, :tag_topic_id, presence: true
    validates :tag_topic_id, uniqueness: {
        scope: :shortened_url_id,
        message: 'This url already has that tag.'
    }

    belongs_to :shortened_url,
        primary_key: :id,
        foreign_key: :shortened_url_id,
        class_name: 'ShortenedUrl'

    belongs_to :tag_topic,
        primary_key: :id,
        foreign_key: :tag_topic_id,
        class_name: 'TagTopic'
end
