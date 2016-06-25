module PostsHelper

  def shorten?(shorten=nil)
    true if shorten == true
  end

  def disqus_shortname(post)
    post.blog.setting.disqus_shortname
  end

  def display_comments?(user_id, post)
    if action_name == 'show' && disqus_shortname(post).present?
      true
    else
      false
    end
  end

  def user
    @user ||= User.find(params[:user_id])
  end
end
