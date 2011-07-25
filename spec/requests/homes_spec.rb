require 'spec_helper'

describe "HomePage" do
  describe "User friends" do
    it "should show user friends on the homepage" do
      user = Summoner.summon(:user, :email => "user@example.com", :password => "secret")
      friend_1 = Summoner.summon(:user, :email => "friend@example.com")
      friend_2 = Summoner.summon(:user, :email => "otherfriend@example.com")

      user.add_friend(friend_1)
      user.add_friend(friend_2)

      login user.email, "secret"

      visit root_path

      page.should have_content friend_1.email
      page.should have_content friend_2.email
    end

    it "should not show non friends on the homepage" do
      user = Summoner.summon(:user, :email => "user@example.com", :password => "secret")
      friend_1 = Summoner.summon(:user, :email => "friend@example.com")
      friend_2 = Summoner.summon(:user, :email => "otherfriend@example.com")

      user.add_friend(friend_1)

      login user.email, "secret"

      visit root_path

      page.should have_content friend_1.email
      page.should_not have_content friend_2.email
    end
  end
end
