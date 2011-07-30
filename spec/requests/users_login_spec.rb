require 'spec_helper'

describe "Request Login" do

  context "Anonymous user" do

    before do
      visit logout_path
    end

    it "should ask to login if anonymous user tries to access homepage" do
      visit root_path
      current_path.should == login_path
    end

    it "should go to homepage after login" do

      Summoner.summon(:user, :email => "donald@duck.com", :password => "cuack")

      visit "/sessions/new"
      fill_in :email, :with => "donald@duck.com"
      fill_in :password, :with => "cuack"
      click "login"
    end
  end 
end
