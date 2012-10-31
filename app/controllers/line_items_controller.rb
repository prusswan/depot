class LineItemsController < ApplicationController
  skip_before_filter :authorize, only: [:create, :destroy, :decrement]

  before_filter :reset_counter, :only => :create

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)
    @line_item.product = product

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url }
        format.js   { @current_item = @line_item }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @cart = @line_item.cart
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to store_url }
      format.js   { render :decrement }
      format.json { head :no_content }
    end
  end

  def decrement
    @line_item = LineItem.find(params[:id])
    @cart = @line_item.cart

    @line_item.quantity -= 1
    if @line_item.quantity > 0
      @line_item.save
      @current_item = @line_item
    else
      @line_item.destroy
    end

    respond_to do |format|
      format.html { redirect_to store_url }
      format.js
      format.json { head :no_content }
    end
  end

  private
    def reset_counter
      session[:counter] = 0
    end
end
