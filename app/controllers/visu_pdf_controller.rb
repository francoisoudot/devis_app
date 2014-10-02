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

end
