class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'application'
  include ActionView::Helpers::DateHelper


def modify_client
binding.pry
render :json => {:form => render_to_string(:partial => 'form')}
end



end
