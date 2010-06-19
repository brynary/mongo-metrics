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

  it "doesn't record cookies by default" do
    set_cookie "__utma=123.4321.123.11"
    get "/"
    request_document["cookies"].should be_nil
  end

  it "records cookies" do
    set_cookie "__utma=123.4321.123.11"
    get "/", {}, { "mongo_metrics.cookies" => ["__utma"] }
    request_document["cookies"]["__utma"].should == "123.4321.123.11"
  end

  it "records cookies that are missing" do
    get "/", {}, { "mongo_metrics.cookies" => ["__utma"] }
    request_document["cookies"]["__utma"].should == nil
  end

  it "records multiple cookies" do
    set_cookie "foo=bar"
    set_cookie "baz=bop"
    get "/", {}, { "mongo_metrics.cookies" => ["foo", "baz"] }
    request_document["cookies"].should == { "foo" => "bar", "baz" => "bop" }
  end
end

