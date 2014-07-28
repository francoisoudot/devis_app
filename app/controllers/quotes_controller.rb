class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy, :index]

  # GET /quotes
  # GET /quotes.json

  def index
    @quotes = Quote.all
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
   @quote = Quote.find(params[:id])
   @client= Client.find_by_id(@quote.client_id)
   @lmax=@quote.list.length
   @total=@quote.total
   @hash=Hash.new
   i=0
     while i<@lmax do
      @hash.merge!({i => @quote.list[i]})
      i=i+1
     end
  end

  # GET /quotes/new
  def new
    @clients = Client
    @alpha=('a'..'z').to_a + ('0'..'9').to_a;
    @quote = Quote.new
  end

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @client=Client.find_by_id(params['q_create']['client'])
    title=params['q_create']['title']
    total=params['q_create']['total']
    l=params['q_create']['list']
    list=Array.new
      l.keys.each do |j|
        list << [l[j][0],l[j][1],l[j][2],l[j][3]]
      end
    quote_p={:title=>title,:total=>total,:list=>list}
    @quote = @client.quotes.create(quote_p)
    format.json { render json: 'Ok' }
    # respond_to do |format|
    #   if @quote.save
    #     format.html { redirect_to index, notice: 'Quote was successfully created.' }
    #     # format.json { render action: 'show', status: :created, location: @quote }
    #   else
    #     format.html { render action: 'new' }
    #     # format.json { render json: @quote.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
  @quote = Quote.find(params[:id])
  title=params['q_update']['title']
  total=params['q_update']['total']
  l=params['q_update']['list']
  list=Array.new
    l.keys.each do |j|
      list << [l[j][0],l[j][1],l[j][2],l[j][3]]
    end
   quote_p={:title=>title,:total=>total,:list=>list}
   @quote.update(quote_p)
   format.json { render json: 'Ok' }
  # respond_to do |format|
  #   if @quote.update(quote_p)
  #       format.html { redirect_to action: 'index'}
  #       # format.json { head :no_content }
  #   else
  #       format.html { redirect_to action: 'index'}
  #       # format.json { render json: @quote.errors, status: :unprocessable_entity }
  #   end
  # end
  end


    # respond_to do |format|
    #   if @quote.update(quote_params)
    #     format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: 'edit' }
    #     format.json { render json: @quote.errors, status: :unprocessable_entity }
    #   end
    # end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params[:quote]
    end
end
