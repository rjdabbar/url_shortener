class ShortenedURL < ActiveRecord::Base
  validates :long_url, presence: true, length: { maximum: 1024 }
  validates :short_url, presence: true, uniqueness: true
  validates :submitter_id, presence: true
  validate :submissions_not_too_frequent

  belongs_to :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings,
    class_name: "Tagging",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :tag_topics,
    through: :taggings,
    source: :tag_topic

  def self.create_for_user_and_long_url!(user, long_url)
    create!(submitter_id: user.id, long_url: long_url, short_url: random_code)
  end

  def self.random_code
    loop do
      random_url = SecureRandom.urlsafe_base64
      return random_url unless exists?(short_url: random_url)
    end
  end
  # ASK ABOUT RUBY VS SQL HERE
  def num_clicks
    Visit.select(:visitor_id).where('shortened_url_id = ?', id).count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    Visit.select(:visitor_id).where('shortened_url_id = ? AND created_at > ?',
     id, 10.minutes.ago).distinct(:visitor_id).count
  end


  private

  def submissions_not_too_frequent
    if ShortenedURL.select(:submitter_id).where('submitter_id = ? AND created_at > ?',
        submitter_id, 1.minute.ago).count > 5
     errors[:submitter_id] << "can't submit more than 5 urls in 1 minute"
    end
  end
end
