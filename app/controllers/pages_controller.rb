class PagesController < ApplicationController
  # just passes through to the view (home.html.erb)
  def home
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
end
