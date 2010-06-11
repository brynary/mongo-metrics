require "spec_helper"
require "fixture/config/environment"

describe MongoMetrics do
  it "records one document per request" do
    get "/", :id => 42
    requests_collection.count.should == 1
  end
end
