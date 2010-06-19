require "spec_helper"

describe MongoMetrics do
  it "records one document per request" do
    get "/"
    requests_collection.count.should == 1
  end

  it "records GET params" do
    get "/", "id" => "42"
    request_document["params"]["id"].should == "42"
  end

  it "records POST params" do
    post "/", "id" => "42"
    request_document["params"]["id"].should == "42"
  end
end
