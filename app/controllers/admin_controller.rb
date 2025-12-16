class AdminController < ApplicationController
  def index
    @total_orders = Order.count
    @user = Current.user
  end
end
