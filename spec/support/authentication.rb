module Authentication
  def login email, password
    visit login_path
    fill_in "email", :with => email
    fill_in "password", :with => password
    click_button "Log In"
  end

  def logout
    visit logout_path
  end
end
