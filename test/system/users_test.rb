require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "should log in" do
    # reset the session and assert the user is logged out:
    Session.delete_all
    visit store_index_url
    assert_selector "li", text: "Login"

    # assert the user is now logged in:
    visit new_session_path
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"

    assert_current_path "/admin"
  end

  test "should log out" do
    # reset the session:
    Session.delete_all
    visit store_index_url

    # assert the user is logged in:
    visit new_session_path
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"

    assert_current_path "/admin"

    # assert the user is now logged out:
    click_button "Logout"
    assert_selector "li", text: "Login"
  end

  test "visiting the users index when logged out should redirect to new_session_path" do
    # reset the session:
    Session.delete_all
    visit users_path
    assert_text "Sign in"
  end

  test "should create user when logged in" do
    # reset the session and assert the user is logged out:
    Session.delete_all
    visit store_index_url
    assert_selector "li", text: "Login"

    # assert the user is now logged in:
    visit new_session_url
    assert_current_path "/session/new"
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"

    assert_current_path "/admin"

    # assert new user has been created:
    visit users_url
    assert_current_path "/users"

    click_on "New user"
    fill_in "Email address", with: "example@example.com"
    fill_in "Name", with: "name"
    fill_in "Password", with: "secret"
    fill_in "Confirm", with: "secret"
    click_on "Create User"

    assert_text "User name was successfully created"
    assert_selector "h1", text: "Users"
  end

  test "should update User when logged in" do
    # reset sessions and log in:
    Session.delete_all    
    visit new_session_path
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"

    assert_current_path "/admin"

    # assert user is updated:
    visit users_url
    click_on "Edit", match: :first
    fill_in "Email address", with: @user.email_address
    fill_in "Name", with: @user.name
    fill_in "Password", with: "secret"
    fill_in "Confirm", with: "secret"
    click_on "Update User"
    assert_text "User #{@user.name} was successfully updated"
  end

  test "should destroy User when logged in" do
    # reset sessions and log in:
    Session.delete_all    
    visit new_session_path
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"

    assert_current_path "/admin"

    # assert user is destroyed:
    visit user_url(@user)
    accept_confirm { click_on "Destroy this user", match: :first }
    assert_text "User was successfully destroyed"
  end
end