class SubInvoiceController < ApplicationController


def create
	title=params['si_param']['title']
	comment=params['si_param']['comment']
	@invoice=Invoice.find(params['si_param']['invoice_id'])
	amount=params['si_param']['sub_inv_amount']
	echeance=params['si_param']['sub_inv_echeance']
	starttime=Time.now
	endtime=echeance.to_i.days.from_now
	status=0
		if @invoice.total_paid==nil
		new_total=amount
		else
		new_total=@invoice.total_paid.to_d+amount.to_d
		end
	# @invoice.update(:total_paid => new_total)
	@sub_invoice= @invoice.sub_invoices.create(:title => title,:total => amount,
		:status => status,:comment => comment, :echeance => echeance, :starttime => starttime,
		:endtime => endtime)
	render json:  {:si_id=>@sub_invoice.id}
end


  def delete
  	@sub_invoice=SubInvoice.find(params[:id])
    @sub_invoice.destroy
    @invoice=Invoice.find(@sub_invoice.invoice_id)
    respond_to do |format|
      format.html { redirect_to invoice_url(@invoice) }
      format.json { head :no_content }
    end
  end

  def mark_paid
  	@sub_invoice=SubInvoice.find(params[:id])
  	amount=@sub_invoice.total
  	@invoice=Invoice.find(@sub_invoice.invoice_id)
  	if @invoice.total_paid==nil
		new_total=amount
	else
		new_total=@invoice.total_paid.to_d+amount.to_d
	end
  	@invoice.update(:total_paid => new_total)
  	@sub_invoice.update(:status => 2)
  	respond_to do |format|
      format.html { redirect_to invoice_url(@invoice) }
      format.json { head :no_content }
    end
  end

    def mark_unpaid
  	@sub_invoice=SubInvoice.find(params[:id])
  	amount=@sub_invoice.total
  	@invoice=Invoice.find(@sub_invoice.invoice_id)
  	if @invoice.total_paid==nil
		new_total=0
	else
		new_total=@invoice.total_paid.to_d-amount.to_d
	end
  	@invoice.update(:total_paid => new_total)
  	@sub_invoice.update(:status => 1)
  	respond_to do |format|
      format.html { redirect_to invoice_url(@invoice) }
      format.json { head :no_content }
    end
  end

end
