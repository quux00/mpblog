# Note this is a module, not class
# that allows the controllers to include the module
# and make the helper methods availble as if they
# were instance methods.
# Because we called this one "application_helper" it
# is included for all controllers.
# So any methods defined here will be automatically 
# available in all views
module ApplicationHelper
  # return title on per page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #@title"
    end
  end
end
