class VisuPdfController < ApplicationController
before_action :authenticate_user!
layout 'application'

def quote_visu
	@quote=Quote.find(params[:format])
        pdf = QuotePdf.new(@quote, view_context)
        send_data pdf.render, 
        filename: "devis.pdf",
        type: "application/pdf",
        disposition: "inline"
        #open in browser otherwise download it
end


def quote_send
@quote = Quote.find(params['m_param']['id'])
    if @quote.email_count==nil
           num_sent=1
    else
            num_sent=@quote.email_count+1
    end
quote_p={:email_count=>num_sent,:starttime=>Time.now}
@quote.update(quote_p)
UserMailer.send_quote2(@quote,params['m_param']['email_to'],
	params['m_param']['email_object'],params['m_param']['email_body'],
	params['m_param']['attachement']).deliver
end

def sub_invoice_visu
@sub_invoice=SubInvoice.find(params[:format])
        pdf = SubinvoicePdf.new(@sub_invoice, view_context)
        send_data pdf.render, 
        filename: "facture.pdf",
        type: "application/pdf",
        disposition: "inline"
end


def sub_invoice_send
@sub_invoice = SubInvoice.find(params['m_param']['siid'])
endtime=@sub_invoice.echeance.to_i.days.from_now
sub_invoice_p={:starttime=>Time.now, :endtime => endtime}
@sub_invoice.update(sub_invoice_p)
UserMailer.send_sub_invoice(@sub_invoice,params['m_param']['email_to'],
	params['m_param']['email_object'],params['m_param']['email_body'],
	params['m_param']['attachement']).deliver
end


def report
    @months=[]
    @cumulated_amount_all_quotes=[]
    @cumulated_amount_accepted_quotes=[]
    @cumulated_amount_all_sub_inv=[]
    @cumulated_amount_accepted_sub_inv=[]
    # @c_a_all_si=[]
    # @c_a_acc_si=[]
    m0=Time.now.strftime('%m').to_i
    y0=("20"+Time.now.strftime('%y')).to_i
    i=5
    while i>=0
        if m0-i <= 0
            m=12+m0-i
            y=y0-1
        else
            m=m0-i
            y=y0
        end
        @months << m
# quote stat
        quotes_all=Quote.by_month(m, field: :starttime, :year => y)
        quotes_accepted=Quote.by_month(m, field: :endtime, :year => y).where(status: '2')
        if quotes_all!=[]
            c_a_all_q=0
            quotes_all.each do |q|
                if q.total!=nil
                    c_a_all_q=c_a_all_q+q.total
                end
            end
        else
            c_a_all_q=0
        end
        if quotes_accepted!=[]
            c_a_acc_q=0
            quotes_accepted.each do |q|
                if q.total!=nil
                    c_a_acc_q=c_a_acc_q+q.total
                end
            end
        else
            c_a_acc_q=0
        end
        @cumulated_amount_all_quotes<<[m,c_a_all_q.to_i]
        @cumulated_amount_accepted_quotes<<[m,c_a_acc_q.to_i]
# invoices stat
        sub_inv_all=SubInvoice.by_month(m, field: :starttime, :year => y)
        sub_inv_accepted=SubInvoice.by_month(m, field: :endtime, :year => y).where(status: '2')
        if sub_inv_all!=[]
            c_a_all_si=0
            sub_inv_all.each do |q|
                if q.total!=nil
                    c_a_all_si=c_a_all_si+q.total
                end
            end
        else
            c_a_all_si=0
        end
        if sub_inv_accepted!=[]
            c_a_acc_si=0
            sub_inv_accepted.each do |q|
                if q.total!=nil
                    c_a_acc_si=c_a_acc_si+q.total
                end
            end
        else
            c_a_acc_si=0
        end
        @cumulated_amount_all_sub_inv<<[m,c_a_all_si.to_i]
        @cumulated_amount_accepted_sub_inv<<[m,c_a_acc_si.to_i]
        # @c_a_all_si<<c_a_all_si
        # @c_a_acc_si<<c_a_acc_si
        i=i-1
    end
    @quotes=Quote.where(status: '2').where('starttime <= ?', 1.week.ago)+Quote.where(status: '1').where('created_at <= ?', 1.week.ago)
    @sub_inv=SubInvoice.where(status: '1').where('endtime<=?',Time.now) + SubInvoice.where(status: '0').where('starttime<=?',Time.now)
    #invoice graph
    # @q_min=([@cumulated_amount_all_quotes.min,@cumulated_amount_accepted_quotes.min].min-1).to_i
    # @q_max=([@cumulated_amount_all_quotes.max,@cumulated_amount_accepted_quotes.max].max+1).to_i
    # @q_scale=(@q_max-@q_min)/5
    # @si_min=([@c_a_all_si.min,@c_a_acc_si.min].min-1).to_i
    # @si_max=([@c_a_all_si.max,@c_a_acc_si.max].max+1).to_i
    # @si_scale=((@si_max-@si_min)/5).to_i


end

end
