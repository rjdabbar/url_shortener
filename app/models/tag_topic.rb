class TagTopic < ActiveRecord::Base
  validates :name, uniqueness: true
end
