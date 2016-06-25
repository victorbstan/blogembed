class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_one :setting

  validates :name, presence: true

  after_create :initialize_setting

private

  def initialize_setting
    setting = self.build_setting
    setting.save!
  end

end
