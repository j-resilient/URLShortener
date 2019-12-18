# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_shortened_urls_on_short_url             (short_url) UNIQUE
#  index_shortened_urls_on_user_id_and_long_url  (user_id,long_url) UNIQUE
#

class ShortenedUrl < ApplicationRecord
    validates :long_url, :user_id, presence: true
    validates :long_url, uniqueness: { 
        scope: :user_id,
        message: 'You have already shortened this URL.'
    }

    belongs_to :submitter,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: 'User'
    
    has_many :visitors,
        primary_key: :id,
        foreign_key: :shortened_url_id,
        class_name: 'Visit'

    def self.create_for_user_and_long_url!(user_id, long_url)
        ShortenedUrl.create! ({
            user_id: user_id,
            long_url: long_url,
            short_url: ShortenedUrl.random_code
        })
    end

    def self.random_code
        code = SecureRandom.urlsafe_base64(16)
        while ShortenedUrl.exists?(:short_url => code)
            code = SecureRandom.urlsafe_base64
        end
        code
    end

    def num_clicks
        visitors.count
    end
end
