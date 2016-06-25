module ApplicationHelper
  def active(path)
    "active" if current_page?(path)
  end

  def path_to_post_for_controller(controller_name, user_id, blog_id, post_id)
    if controller_name == 'embeds'
      user_blog_embed_url(user_id, blog_id, post_id)
    else
      user_blog_post_url(user_id, blog_id, post_id)
    end
  end

  def is_allowed?(user_id)
    if current_user && current_user.id == user_id.to_i
      true
    else
      false
    end
  end

  def markdowner(copy)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true,
      prettify: true,
      safe_links_only: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      tables: true
    )
    markdown.render(copy).html_safe
  end
end
