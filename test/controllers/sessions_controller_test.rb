# require 'test_helper'
# 
# class SessionsControllerTest < ActionDispatch::IntegrationTest
#   describe "SessionsController" do
#     before do
#       account_one = :accounts
#       register(account_one)
#     end
#     describe "#create" do
#       before do
#         sign_in(account_one)
#       end
# 
#       it "creates the session token" do
#         assert_not_nil cookies[:token]
#       end
#     end
#   end
# end
# 
# # 
# #       # it "returns ok" do
# #       #   assert_response :ok
# #       # end
# # 
# #       # it "returns session token" do
# #       #   json = JSON.parse(@response.body)
# #       #   assert !json["token"].nil?
# #       # end
# #     end
# # 
# #   #   describe "#destroy" do
# #   #     before do
# #   #       sign_out :account_one
# #   #     end
# # 
# #   #     it "destroys the session object" do
# #   #       skip
# #   #     end
# # 
# #   #     it "resets the app session" do
# #   #       skip
# #   #     end
# # 
# #   #     it "returns ok" do
# #   #       skip
# #   #     end
# # 
# #   #     it "returns an empty response" do
# #   #       skip
# #   #     end
# #   #   end
# # 
# #   #   describe "when a token is not passed as a param but app session exists" do
# #   #     it "destroys the session object" do
# #   #       skip
# #   #     end
# # 
# #   #     it "resets the app session" do
# #   #       skip
# #   #     end
# # 
# #   #     it "returns ok" do
# #   #       skip
# #   #     end
# #   #   end
# # 
# #   #   describe "when a token is not passed as a param and an app session does not exist" do
# #   #     it "returns not found" do
# #   #       skip
# #   #     end
# #   #   end
# #   end
# # 
#   private
# 
#   def register(account)
#     open_session do |s|
#       a = :accounts(account)
#       s.post '/register', name: a.name, password: a.password
#     end
#   end
# 
#   def sign_in(account)
#     open_session do |s|
#       a = :accounts(account)
#       s.post "/sign_in", name: a.name, password: a.password
#     end
#   end
# 
#   def sign_out(account)
#     open_session do |s|
#       a = :accounts(account)
#       s.post '/sign_out', id: a.id
#     end
#   end
# # end
