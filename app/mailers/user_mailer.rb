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
def send_quote2(quote,to,obj,bod,att)
    @quote=quote
    @client= Client.find_by_id(@quote.client_id)
    mail_to=to
    mail_object=obj
    mail_body=bod
    subject=mail_object
    if att=="true"
      pdf = QuotePdf.new(@quote, view_context)
      attachments["invoice.pdf"] = { :mime_type => 'application/pdf', :content => pdf.render }
    end
    if @client.email != nil
      mail(from:'no-reply@whatever.net',
            to: mail_to, 
           subject: subject,
           body: mail_body
           )
    end
  end
 


end
