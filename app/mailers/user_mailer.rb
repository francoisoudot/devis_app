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
            from: 'no-reply@whatever.net', 
            cc: "alexis.bidinot@gmail.com",
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
      mail(to: mail_to, 
           from: 'no-reply@whatever.net', 
           cc: "alexis.bidinot@gmail.com",
           subject: subject,
           body: mail_body
           )
    end
  end
 
 def send_sub_invoice(sub_invoice,to,obj,bod,att)
    @sub_inv=sub_invoice
    @sub_inv.update(:status => 1)
    @invoice=Invoice.find(@sub_inv.invoice_id)
    @client=Client.find_by_id(@invoice.client_id)    
    mail_to=to
    mail_object=obj
    mail_body=bod
    subject=mail_object
    if att=="true"
      pdf = SubinvoicePdf.new(@sub_inv, view_context)
      attachments["invoice.pdf"] = { :mime_type => 'application/pdf', :content => pdf.render }
    end
    if @client.email != nil
      mail(to: mail_to, 
           from: 'no-reply@whatever.net', 
           cc: "alexis.bidinot@gmail.com",
           subject: subject,
           body: mail_body
           )
    end
  end


end
