class Visit < ActiveRecord::Base
  validates :visitor_id, presence: true
  validates :shortened_url_id, presence: true

  

  def self.record_visit!(user, shortened_url)
    new(visitor_id: user.id, shortened_url_id: shortened_url.id)
  end
end
