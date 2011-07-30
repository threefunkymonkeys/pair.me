def click(finder)
  begin 
    click_link finder  
  rescue Webrat::NotFoundError
    click_button finder
  end
end

def current_path
  request.path
end

def page
  response.body
end

class String
  alias_method :has_content?, :include?
end
