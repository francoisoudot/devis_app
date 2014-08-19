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


end
