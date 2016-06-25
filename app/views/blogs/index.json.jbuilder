json.array!(@blogs) do |blog|
  json.extract! blog, :name, :description, :enable
  json.url blog_url(blog, format: :json)
end
