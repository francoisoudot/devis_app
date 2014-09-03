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
   # @clients = Client
   # @alpha=('a'..'z').to_a + ('0'..'9').to_a
   @client= Client.find_by_id(@quote.client_id)
   @lmax=@quote.list.length
   @total=@quote.total
   @tax_rate=@quote.tax_rate
   if @tax_rate==nil
     @tax_rate=0
   end
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
    @alpha=('a'..'z').to_a + ('0'..'9').to_a
    @quote = Quote.new
  end

  # GET /quotes/1/edit
  def edit
    @quote = Quote.find(params[:id])
    UserMailer.send_quote(@quote).deliver
    respond_to do |format|
      format.html { redirect_to quotes_url }
      format.json { head :no_content }
    end
  end

  # POST /quotes
  # POST /quotes.json
def create
  @client=Client.find_by_id(params['q_param']['client'])
  title=params['q_param']['title']
  total=params['q_param']['total']
  tax_rate=params['q_param']['tax_rate']
  l=params['q_param']['list']
  list=Array.new
    l.keys.each do |j|
      list << [l[j][0],l[j][1],l[j][2],l[j][3]]
    end
  quote_p={:title=>title,:total=>total,:list=>list,:tax_rate=>tax_rate}
  @quote = @client.quotes.create(quote_p)
  render json:  {:quote_id=>@quote.id}

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
  title=params['q_param']['title']
  total=params['q_param']['total']
  tax_rate=params['q_param']['tax_rate']
  l=params['q_param']['list']
  comment=params['q_param']['comment']
  list=Array.new
    l.keys.each do |j|
      list << [l[j][0],l[j][1],l[j][2],l[j][3]]
    end
   quote_p={:title=>title,:total=>total,:list=>list,:tax_rate=>tax_rate,:comment=>comment}
   @quote.update(quote_p)
   send_quote (@quote)

  # respond_to do |format|
  #   if @quote.update(quote_p)
  #       format.html {}
        format.json { head :no_content }
  #   else
  #       format.html {}
  #       format.json { render json: @quote.errors, status: :unprocessable_entity }
  #   end
  # end
  end

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
    # def send_quote(quote)
    #   @quote=quote
    #   if params['q_param']['q_send']=="true"
    #     UserMailer.send_quote(@quote).deliver
    #   end


    # end


    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params[:quote]
    end
end
