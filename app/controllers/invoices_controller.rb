class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
     @invoice = Invoice.find(params[:id])
   # @clients = Client
   # @alpha=('a'..'z').to_a + ('0'..'9').to_a
   @client= Client.find_by_id(@invoice.client_id)
   if @invoice.list==nil
    @lmax=0
    else
   @lmax=@invoice.list.length
   end
   if @invoice.total==nil
    @total=0
    else
   @total=@invoice.total
   end
   @tax_rate=@invoice.tax_rate
   if @tax_rate==nil
     @tax_rate=0
   end
   if @invoice.total_paid==nil
    @total_paid=0
    else
   @total_paid=@invoice.total_paid
   end
   @hash=Hash.new
   i=0
     while i<@lmax do
      @hash.merge!({i => @invoice.list[i]})
      i=i+1
     end
     if @lmax==0
      @hash={0=>["", "", "", ""]}
    end
    @pourc_paid=100 * @total_paid.to_d / (@total.to_d*(1+@tax_rate.to_d))
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render action: 'show', status: :created, location: @invoice }
      else
        format.html { render action: 'new' }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
  @invoice = Invoice.find(params[:id])
  title=params['q_param']['title']
  total=params['q_param']['total']
  tax_rate=params['q_param']['tax_rate']
  l=params['q_param']['list']
  comment=params['q_param']['comment']
  list=Array.new
    l.keys.each do |j|
      list << [l[j][0],l[j][1],l[j][2],l[j][3]]
    end
    binding.pry
   invoice={:title=>title,:total=>total,:list=>list,:tax_rate=>tax_rate,:comment=>comment}
   @invoice.update(invoice)
   format.json { head :no_content }
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      # params[:invoice]
    end
end
