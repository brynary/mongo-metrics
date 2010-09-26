require "mongo_metrics"

class ApplicationController < ActionController::Base
  use MongoMetrics

  def hello
    session[:counter] ||= 1
    session[:counter] += 1
    render :text => "hello"
  end

end
