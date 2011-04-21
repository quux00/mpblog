module UsersHelper
  def gravatar_for(user, options = {:size => 50})
    # replacement 'local' code instead
    image_tag('gecko-logo.jpg', 
              :class => 'gravatar',
              :alt => user.name);
              
    # I don't actually want to use this so I can run tests while offline
    # gravatar_image_tag(user.email.downcase, 
    #                    :alt => user.name,
    #                    :class => 'gravatar',
    #                    :gravatar => options)
  end
end
