module ApplicationHelper
  def title
    if content_for?(:title)
      content_for(:title)
    else
      'Arch Http Gateway'
    end
  end
end
