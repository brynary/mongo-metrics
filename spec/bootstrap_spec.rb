require "spec_helper"
require "fixture/config/environment"

describe MongoMetrics do
  it "does nothing yet" do
    get("/").status.should == 404
  end
end
