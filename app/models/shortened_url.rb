class ShortenedURL < ActiveRecord::Base
  validates :long_url, presence: true
  validates :short_url, presence: true, uniqueness: true
  validates :submitter_id, presence: true

  belongs_to :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :visitors,
    through: :visits,
    source: :visitor

  def self.create_for_user_and_long_url!(user, long_url)
    new(submitter_id: user.id, long_url: long_url, short_url: random_code)
  end

  def self.random_code
    loop do
      random_url = SecureRandom.urlsafe_base64
      return random_url unless exists?(short_url: random_url)
    end
  end
end
