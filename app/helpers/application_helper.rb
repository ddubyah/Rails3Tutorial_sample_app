module ApplicationHelper
  # Return a title on a per-page basis
  def title
    base_title = "DDubyah's Ruby on Rails Tutorial Site"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    # following line returns the image_tag - 'return' keyword is unecessary since the final term in the method is returned automatically
    image_tag("logo.png", :alt => "Sample App", :class => "round")    
  end
    
end
