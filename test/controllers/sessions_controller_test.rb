require 'test_helper'

describe "SessionsController" do
  before do
    CWB::Session.client_class = MockCWB
  end

  after do
    CWB::Session.client_class = nil
  end

  describe "#create" do
    before do
      post :create
    end

    it "creates the session object" do
      MockCWB.calls.must_include :insert_data
    end

    it "creates the app session" do
      session.must_include :token
    end

    it "returns ok" do
      assert_response :ok
    end

    it "returns session token" do
      json = JSON.parse(@response.body)
      assert !json["token"].nil?
    end
  end

  describe "#destroy" do
    before do
    end

    describe "when a token is passed as a param" do
      it "destroys the session object" do
        skip
      end

      it "resets the app session" do
        skip
      end

      it "returns ok" do
        skip
      end

      it "returns an empty response" do
        skip
      end
    end

    describe "when a token is not passed as a param but app session exists" do
      it "destroys the session object" do
        skip
      end

      it "resets the app session" do
        skip
      end

      it "returns ok" do
        skip
      end
    end

    describe "when a token is not passed as a param and an app session does not exist" do
      it "returns not found" do
        skip
      end
    end
  end
end
