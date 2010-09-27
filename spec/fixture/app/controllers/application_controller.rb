class ApplicationController < ActionController::Base

  def hello
    session[:counter] ||= 1
    session[:counter] += 1
    render :text => "hello"
  end

end
