require "spec_helper"

describe MongoMetrics::Options do
  it "has default options" do
    options = MongoMetrics::Options.new
    options["mongo_metrics.cookies"].should == ["__utma"]
  end

  it "accesses options as symbols" do
    options = MongoMetrics::Options.new
    options[:cookies].should == ["__utma"]
  end

  it "allows customized defaults" do
    options = MongoMetrics::Options.new("mongo_metrics.cookies" => ["foo"])
    options[:cookies].should == ["foo"]
  end

  it "allows customized defaults as symbols" do
    options = MongoMetrics::Options.new(:cookies => ["foo"])
    options[:cookies].should == ["foo"]
  end

  it "doesn't allow invalid options" do
    options = MongoMetrics::Options.new(:foo => "bar")
    options[:foo].should be_nil
  end

  it "allows per-request options" do
    options = MongoMetrics::Options.new({}, :cookies => ["foo"])
    options[:cookies].should == ["foo"]
  end

  it "overrides customized defaults with per-requets options" do
    options = MongoMetrics::Options.new(:cookies => ["foo"], :cookies => ["bar"])
    options[:cookies].should == ["bar"]
  end
end

