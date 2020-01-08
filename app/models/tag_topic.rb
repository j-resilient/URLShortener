# == Schema Information
#
# Table name: tag_topics
#
#  id         :bigint           not null, primary key
#  tag_topic  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tag_topics_on_tag_topic  (tag_topic)
#

class TagTopic < ApplicationRecord
    validates :tag_topic, presence: true, uniqueness: true

    has_many :shortened_urls,
        primary_key: :id,
        foreign_key: :tag_topic_id,
        class_name: 'Tagging',
        dependent: :destroy

    has_many :urls,
        through: :shortened_urls,
        source: :shortened_url

    # popular_links
    # get all links for a topic
    # sort by num_clicks : limit to 5

    def popular_links
        urls.sort_by { |url| -url.num_clicks }.take(5)
    end
end
