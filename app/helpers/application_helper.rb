module ApplicationHelper
  def truncate_content(content, length)
    strip_tags(content.to_s).gsub(/[\n]/,"").strip.truncate(length)
  end
end