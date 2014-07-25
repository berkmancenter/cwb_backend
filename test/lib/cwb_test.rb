require 'test_helper'
require 'cwb'

describe "CWB" do

  it "has a frozen uri" do
    assert CWB::BASE_URI.frozen?
  end

  describe "::sparql" do
    it "creates and returns a sparql client" do
      puts CWB.sparql
      CWB.sparql.must_be_instance_of SPARQL::Client
    end

    it "accepts query mode" do
      CWB.sparql(:query).must_be_instance_of SPARQL::Client
    end

    it "accepts update mode" do
      CWB.sparql(:update).must_be_instance_of SPARQL::Client
    end

    it "handles invalid modes" do
      proc { CWB.sparql(:foo) }.must_raise ArgumentError
    end
  end
end
