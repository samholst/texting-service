class PagesController < ApplicationController

  # For the search purpose, I'm not adding in user verification,
  # rather I'm making a public access page to view all texts
  # with no authentication or authorization.
  def home
    @text_messages = if params[:number]
      TextMessage.where(to_number: params[:number])
    else
      TextMessage.all
    end
  end
end
