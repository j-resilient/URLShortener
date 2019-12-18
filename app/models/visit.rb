# == Schema Information
#
# Table name: visits
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  shortened_url_id :integer          not null
#  user_id          :integer          not null
#
# Indexes
#
#  index_visits_on_shortened_url_id  (shortened_url_id)
#  index_visits_on_user_id           (user_id)
#

class Visit < ApplicationRecord
    validates :user_id, :shortened_url_id, presence: true 

    def self.record_visit!(user, shortened_url)
        Visit.create! ({
            user_id: user.id,
            shortened_url_id: shortened_url.id
        })
    end
end
