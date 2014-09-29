class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index

   @order=params[:order].to_i
   @tab=params[:tab].to_i
   if @tab==0 && @order==0
     @invoices = Invoice.all
     @sub_inv=SubInvoice.order("endtime")
     @tab1=""
     @tab2="active"
   elsif @tab==1
    @tab1="active"
    @tab2=""
    @sub_inv=SubInvoice.order("endtime")
    if @order==1
      @invoices=Invoice.order(title: :asc).all
    elsif @order==2
      @invoices=Invoice.order(title: :desc).all
    elsif @order==3
      @invoices=Invoice.joins("left join clients on invoices.client_id = clients.id").order("clients.last_name DESC")
    elsif @order==4
      @invoices=Invoice.joins("left join clients on invoices.client_id = clients.id").order("clients.last_name DESC")
    elsif @order==5
      @invoices=Invoice.order(total: :asc).all
    elsif @order==6
      @invoices=Invoice.order(total: :desc).all
    elsif @order==7
      @invoices=Invoice.order(created_at: :desc).all
    elsif @order==8
      @invoices=Invoice.order(created_at: :asc).all
    elsif @order==9
      @invoices=Invoice.order(total_paid: :asc).all
    elsif @order==10
      @invoices=Invoice.order(total_paid: :desc).all
    elsif @order==11
      @invoices=Invoice.order("invoices.total_paid/(invoices.total*(1+invoices.tax_rate)) ASC")
    elsif @order==12
      @invoices=Invoice.order("invoices.total_paid/(invoices.total*(1+invoices.tax_rate)) DESC")
    end
    
   else
    @tab1=""
    @tab2="active"
    @invoices = Invoice.all
    if @order==1
      @sub_inv=SubInvoice.order(id: :asc).all
    elsif @order==2
      @sub_inv=SubInvoice.order(id: :desc).all
    elsif @order==3
      @sub_inv=SubInvoice.order(title: :asc).all
    elsif @order==4
      @sub_inv=SubInvoice.order(title: :desc).all
    elsif @order==5
      @sub_inv=SubInvoice.order(endtime: :asc).all
    elsif @order==6
      @sub_inv=SubInvoice.order(endtime: :desc).all
    elsif @order==7
      @sub_inv=SubInvoice.order(total: :asc).all
    elsif @order==8
      @sub_inv=SubInvoice.order(total: :desc).all
    elsif @order==9
      @sub_inv=SubInvoice.order(status: :asc).all
    elsif @order==10
      @sub_inv=SubInvoice.order(status: :desc).all
    elsif @order==11
      @sub_inv=SubInvoice.joins("left join invoices on sub_invoices.invoice_id=invoices.id").joins("left join clients on invoices.client_id = clients.id").order("clients.last_name ASC")
    elsif @order==12
      @sub_inv=SubInvoice.joins("left join invoices on sub_invoices.invoice_id=invoices.id").joins("left join clients on invoices.client_id = clients.id").order("clients.last_name DESC")
    end
   end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
     @invoice = Invoice.find(params[:id])
     @sub_inv=@invoice.sub_invoices.order("endtime")
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
    if @total == 0
      @pourc_paid=0
    else
      @pourc_paid=(100 * @total_paid.to_d / (@total.to_d*(1+@tax_rate.to_d))).to_i 
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @clients = Client
    @alpha=('a'..'z').to_a + ('0'..'9').to_a
  end

def new_invoice
    @quotes = Quote.where(status: 1)
end


  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    if params['q_param']['quote_id']!=nil
      @quote_id=params['q_param']['quote_id']
      @quote=Quote.find(@quote_id)
      client_id= @quote.client_id
      list=@quote.list
      total=@quote.total
      tax_rate=@quote.tax_rate
      @quote.update({:status=>2})
      title=@quote.title
      comment=@quote.comment
    else 
      client_id=params['q_param']['client']
      @quote_id=nil
      list=nil
      total=nil
      tax_rate=nil
      title=params['q_param']['title']
      comment=params['q_param']['comment']
    end
    @client=Client.find_by_id(client_id)
    invoice_p={:title=>title,:comment=>comment,:quote_id=>@quote_id,:total=>total,:list=>list,:tax_rate=>tax_rate,}
    @invoice = @client.invoices.create(invoice_p)
    render json:  {:invoice_id=>@invoice.id}
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
   invoice={:title=>title,:total=>total,:list=>list,:tax_rate=>tax_rate,:comment=>comment}
   @invoice.update(invoice)
   format.json { head :no_content }
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice=Invoice.find(params[:id])
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      # @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      # params[:invoice]
    end
end
