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
end
