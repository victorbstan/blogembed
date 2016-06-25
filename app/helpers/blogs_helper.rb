module BlogsHelper
  def primary?(blog)
    blog.enable? ? "panel-info" : ""
  end
end
