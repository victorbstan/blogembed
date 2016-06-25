class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :blogs

  after_create :initialize_blog

  private

  def initialize_blog
    self.transaction do
      blog = Blog.create(user_id: self.id, name: 'Blog', description: 'My First Blog', enable: true)
      Setting.create(blog: blog)
    end
  end
end
