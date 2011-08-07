require 'spec_helper'

describe "Editor" do
  let(:eddie) { Summoner.summon(:user, :email => "ed@vedder.com", :password => "secret") }
  let(:jeff) { Summoner.summon(:user, :email => "jeff@ament.com", :password => "not_so_secret") }

  it "should invite a friend to share a file" do
    eddie.add_friend(jeff)
    login "ed@vedder.com", "secret"

    visit root_path
    click "jeff@ament.com"
    current_path.should == "/users/#{eddie.id}/editor/#{jeff.id}"

    page.should have_content "Waiting for jeff@ament.com"
    page.should have_content "Drag a file to the window"
  end
end
