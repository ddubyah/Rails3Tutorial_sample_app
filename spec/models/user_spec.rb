require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {:name => "Example User", :email => "user@example.com"}
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are longer than 50 chars" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should reject invalid emails" do
    bad_addresses = %w[user@foo,com user_at_foo.org, example.user@foo.]
    bad_addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USR@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject duplicate emails" do
    User.create!(@attr) # puts a user in the db so we have something to test with
    duplicate_user = User.new(@attr)
    duplicate_user.should_not be_valid
  end
  
  it "should reject duplicate emails reguardless of case" do
    upcase_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcase_email))
    duplicate_user = User.new(@attr)
    duplicate_user.should_not be_valid
    duplicate_user = User.new()
  end
  
end
