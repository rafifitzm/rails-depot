class StoreController < ApplicationController
  allow_unauthenticated_access
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
    @disable_checkout_button_flag = false
  end
end
