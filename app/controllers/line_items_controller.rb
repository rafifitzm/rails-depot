class LineItemsController < ApplicationController
  allow_unauthenticated_access only: %i[ show create destroy ]
  include CurrentCart
  before_action :set_cart, only: %i[ create destroy ]

  before_action :set_line_item, only: %i[ show edit update destroy ]

  # GET /line_items or /line_items.json
  def index
    # prevent users from accessing other cart's line items
    redirect_to store_index_url
    # @line_items = LineItem.all
  end

  # GET /line_items/1 or /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.turbo_stream { @current_item_add = @line_item }
        format.html { redirect_to store_index_url }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: "Line item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    if params[:set_to_zero]
      @line_item.quantity = 1
    end
    unless @line_item.quantity == 1
      @line_item.quantity -= 1
      @line_item.price = @line_item.product.price * @line_item.quantity
    else
      @line_item.destroy!
    end
    
    respond_to do |format|
      if @line_item.save
        format.turbo_stream { @current_item_del = @line_item }
        # format.turbo_stream do
        #   @current_item_del = @line_item
        #   render turbo_stream: turbo_stream.replace(:cart, partial: 'layouts/cart', locals: { cart: @cart })
        # end
        format.html { redirect_to store_index_url }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.turbo_stream { @notice = "#{@line_item.product.title} was successfully removed from cart" }
        format.html { redirect_to store_index_url, status: :see_other, notice: "#{@line_item.product.title} was successfully removed from cart" }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.expect(line_item: [ :product_id ])
    end
end
