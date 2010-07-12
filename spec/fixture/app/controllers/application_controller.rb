class ApplicationController < ActionController::Base
  use MongoMetrics

  def hello
    render :text => "hello"
  end

end
