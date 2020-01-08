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
    validates :long_url, :user_id, :short_url, presence: true
    validates :long_url, uniqueness: { 
        scope: :user_id,
        message: 'You have already shortened this URL.'
    }
    validate :no_spamming, :nonpremium_max

    belongs_to :submitter,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: 'User'

    has_many :visits,
        primary_key: :id,
        foreign_key: :shortened_url_id,
        class_name: 'Visit', 
        dependent: :destroy
    
    has_many :visitors,
        -> { distinct },
        through: :visits,
        source: :user
    
    has_many :tags,
        primary_key: :id,
        foreign_key: :shortened_url_id,
        class_name: 'Tagging',
        dependent: :destroy

    has_many :tag_topics,
        through: :tags,
        source: :tag_topic

    def self.create_for_user_and_long_url!(user, long_url)
        short_url = ShortenedUrl.random_code
        ShortenedUrl.create! ({
            user_id: user.id,
            long_url: long_url,
            short_url: short_url
        })
        short_url
    end

    def self.random_code
        loop do
            code = SecureRandom.urlsafe_base64
            return code unless ShortenedUrl.exists?(:short_url => code)
        end
    end

    def self.prune(min)
        ShortenedUrl
           .joins(:submitter)
           .joins('LEFT JOIN visits ON shortened_urls.id = visits.shortened_url_id')
           .where("(shortened_urls.id IN (
               SELECT shortened_urls.id
               FROM shortened_urls
               JOIN visits
               ON shortened_urls.id = visits.shortened_url_id
               GROUP BY shortened_urls.id
               HAVING MAX(visits.created_at) < \'#{min.minute.ago}\'
           ) OR (
               visits.id IS NULL and shortened_urls.created_at < \'#{min.minute.ago}\'
           )) AND users.premium = \'f\'")
           .destroy_all
    end

    def num_clicks
        visits.count
    end

    def num_uniques
        visitors.count
    end

    def num_recent_uniques
        visits
           .where("created_at >= ?", 10.minutes.ago)
           .select(:user_id)
           .distinct
           .count
    end

    def no_spamming
        user = User.find(user_id)
        urls = user
               .submitted_urls
               .where("created_at <= ?", 1.minutes.ago)
        if urls.length >= 5
            errors[:user_id] << 'can\'t submit more than five URLs in a minute'
        end
    end

    def nonpremium_max
        user = User.find(user_id)
        return if user.premium 
        if user.submitted_urls.count >= 5
            errors[:Only] << 'premium members can save more than 5 URLs'
        end
    end
end
