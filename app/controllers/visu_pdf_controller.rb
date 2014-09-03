class VisuPdfController < ApplicationController

def quote_visu
	@quote=Quote.find(params[:format])
        pdf = QuotePdf.new(@quote, view_context)
        send_data pdf.render, 
        filename: "invoice.pdf",
        type: "application/pdf",
        disposition: "inline"
        #open in browser otherwise download it
end


def quote_send
@quote = Quote.find(params['m_param']['id'])
UserMailer.send_quote2(@quote,params['m_param']['email_to'],
	params['m_param']['email_object'],params['m_param']['email_body'],
	params['m_param']['attachement']).deliver
end


end
