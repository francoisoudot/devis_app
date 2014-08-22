class UserMailer < ActionMailer::Base
  default from: 'no-reply@whatever.net',
          reply_to: 'francois.oudot@gmail.com'


  def send_quote(quote)
  	@quote=quote
    @client= Client.find_by_id(@quote.client_id)
    subject='Réponse à votre demande de devis pour '+@quote.title+ " de l'entreprise flatty"
    pdf = QuotePdf.new(@quote, view_context)
    attachments["invoice.pdf"] = { :mime_type => 'application/pdf', :content => pdf.render }
  	if @client.email != nil
    	mail(to: @client.email, 
           subject: subject
           )
    end
  end

 


end
