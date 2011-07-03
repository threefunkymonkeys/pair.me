require 'spec_helper'

describe User do
  it "should have friends" do
    user = User.create(:email => "user@somewhere.com", :password => "secret", :password_confirmation => "secret")
    friend = User.create(:email => "friend@somewhere.com", :password => "secret", :password_confirmation => "secret")

    user.add_friend(friend)
    user.friends.should include friend
  end
end
