require "spec_helper"

describe MongoMetrics do
  it "records one document per request" do
    get "/"
    document.should_not be_nil
  end

  it "records the URL" do
    get "/", "foo" => "bar"
    document["url"].should == "http://example.org/?foo=bar"
  end

  it "records the URL path" do
    get "/", "foo" => "bar"
    document["path"].should == "/"
  end

  it "records the response code" do
    get "/"
    document["status"].should == 200
  end

  it "records the HTTP method" do
    put "/"
    document["request_method"].should == "PUT"
  end

  it "records the URL scheme" do
    get "/", {}, { "rack.url_scheme" => "https" }
    document["url_scheme"].should == "https"
  end

  it "records the Host" do
    get "/"
    document["host"].should == "example.org"
  end

  it "records the remote IP address" do
    header "X-Forwarded-For", "10.0.0.200"
    get "/"
    document["remote_ip"].should == "10.0.0.200"
  end

  it "records GET params" do
    get "/", "id" => "42"
    document["params"]["id"].should == "42"
  end

  it "records POST params" do
    post "/", "id" => "42"
    document["params"]["id"].should == "42"
  end

  it "doesn't record cookies when disabled" do
    set_cookie "__utma=123.4321.123.11"
    get "/", {}, { "mongo_metrics.cookies" => nil }
    document["request"]["cookies"].should be_nil
  end

  it "records cookies" do
    set_cookie "__utma=123.4321.123.11"
    get "/"
    document["request"]["cookies"]["__utma"].should == "123.4321.123.11"
  end

  it "records cookies that are missing" do
    get "/", {}, { "mongo_metrics.cookies" => ["__utma"] }
    document["request"]["cookies"]["__utma"].should == nil
  end

  it "records multiple cookies" do
    set_cookie "foo=bar"
    set_cookie "baz=bop"
    get "/", {}, { "mongo_metrics.cookies" => ["foo", "baz"] }
    document["request"]["cookies"].should == { "foo" => "bar", "baz" => "bop" }
  end

  it "records the user agent header" do
    header "User-Agent", "Chrome"
    get "/"
    document["user_agent"].should == "Chrome"
  end

  it "records the response content type" do
    header "Content-Type", "application/json"
    get "/"
    document["request"]["content_type"].should == "application/json"
  end

  it "records the controller name" do
    get "/"
    document["controller_name"].should == "application"
  end

  it "records the action name" do
    get "/"
    document["action_name"].should == "hello"
  end

  it "records specified request HTTP headers" do
    header "Foo", "Bar"
    get "/", {}, { "mongo_metrics.request_headers" => [ "Foo" ] }
    document["request"]["headers"]["Foo"].should == "Bar"
  end

  it "records specified session values" do
    get "/", {}, { "mongo_metrics.session_keys" => [ "counter" ] }
    document["request"]["session"]["counter"].should be_nil
    clear_documents
    get "/", {}, { "mongo_metrics.session_keys" => [ "counter" ] }
    document["request"]["session"]["counter"].should == 2
  end

  it "filters params stores to Mongo" do
    get "/", "password" => "secret"
    document["params"]["password"].should == "[FILTERED]"
  end

  it "does not store uploaded files"
  it "does not store arbitrary post bodies"
end

