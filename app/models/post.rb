class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog

  def to_param
    "#{self.id}-#{self.created_at.strftime("%Y-%m-%d").parameterize}-#{self.title.parameterize}"
  end
end
