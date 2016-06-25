class Setting < ActiveRecord::Base
  belongs_to :blog

  validates :blog_id, uniqueness: true
end
