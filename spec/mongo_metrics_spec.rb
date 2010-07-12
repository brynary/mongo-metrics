require "spec_helper"

describe MongoMetrics do
  it "records one document per request" do
    get "/"
    requests_collection.count.should == 1
  end

  it "records the URL" do
    get "/", "foo" => "bar"
    request_document["url"].should == "http://example.org/?foo=bar"
  end

  it "records the URL path" do
    get "/", "foo" => "bar"
    request_document["path"].should == "/"
  end

  it "records the response code" do
    get "/"
    request_document["status"].should == 200
  end

  it "records the HTTP method" do
    put "/"
    request_document["request_method"].should == "PUT"
  end

  it "records the URL scheme" do
    get "/", {}, { "rack.url_scheme" => "https" }
    request_document["url_scheme"].should == "https"
  end

  it "records the Host" do
    header "Host", "example.com:80"
    get "/"
    request_document["host"].should == "example.com:80"
  end

  it "records the remote IP address" do
    header "X-Forwarded-For", "10.0.0.200"
    get "/"
    request_document["remote_ip"].should == "10.0.0.200"
  end

  it "records GET params" do
    get "/", "id" => "42"
    request_document["params"]["id"].should == "42"
  end

  it "records POST params" do
    post "/", "id" => "42"
    request_document["params"]["id"].should == "42"
  end

  it "doesn't record cookies when disabled" do
    set_cookie "__utma=123.4321.123.11"
    get "/", {}, { "mongo_metrics.cookies" => nil }
    request_document["cookies"].should be_nil
  end

  it "records cookies" do
    set_cookie "__utma=123.4321.123.11"
    get "/"
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

  it "records the user agent header" do
    header "User-Agent", "Chrome"
    get "/"
    request_document["user_agent"].should == "Chrome"
  end

  it "records specified request HTTP headers"
  it "records the response content type"
  it "records specified session values"
  it "filters params stores to Mongo"
  it "does not store uploaded files"
  it "does not store arbitrary post bodies"
end

