require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  # Yes, you should absolutely split this task into two separate tests. One test should verify that the "Add to Cart" button reveals the cart, and the other should verify that the "Empty Cart" button hides it.
  test "'Add to Cart' should reveal the cart" do
    # Reset cart and go to store_index
    LineItem.delete_all

    visit store_index_url

    # Cart should be hidden at first, then clicking "Add to Cart" should reveal cart

    assert_no_selector "h2", text: "Your Cart"

    click_on "Add to Cart", match: :first

    assert_selector "h2", text: "Your Cart"
  end

  test "'Empty Cart' should hide the cart" do
    # Reset cart and go to store_index
    LineItem.delete_all

    visit store_index_url

    # Add something to the cart and check that the cart is visible

    click_on "Add to Cart", match: :first

    assert_selector "h2", text: "Your Cart"

    # Clicking on "Empty Cart" should hide the cart

    click_on "Empty Cart"

    assert_no_selector "h2", text: "Your Cart"
    # Gemini response:
    # Yes, if assert_no_selector works, you can conclude that the test is good enough. The primary goal of this specific test is to confirm that the cart is removed from the page after you click the "Empty Cart" button. The assert_no_selector method is the most appropriate and direct way to verify this behavior.
    # The fact that assert_selector fails to fail is puzzling, but it points to a very subtle edge case, likely a timing issue or a Capybara configuration quirk. While it's confusing, it doesn't invalidate your test. The assert_no_selector is the correct tool for the job.
    # Focus on the assertion that proves the functionality you care about. Since you're testing that the cart is hidden, the correct assertion to make is that the cart is not present on the page. assert_no_selector does exactly that.
  end

  test "added line item should have line-item-highlight-add css class" do
    # reset cart
    LineItem.delete_all
    Cart.delete_all
    visit store_index_url

    click_on "Add to Cart", match: :first
    assert_selector ".line-item-highlight-add"
  end

  test "decremented line item should have line-item-highlight-del css class" do
    # reset cart and sessions and cart setup:
    Session.delete_all
    LineItem.delete_all
    Cart.delete_all
    visit store_index_url
    click_on "Add to Cart", match: :first
    # click_on "Add to Cart", match: :first
      
    click_button "+", match: :first
    click_button "-", match: :first
    assert_selector ".line-item-highlight-del"
  end
end