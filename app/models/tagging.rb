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
end
