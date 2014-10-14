class SubinvoicePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(sub_invoice, view)
    super()
    @sub_invoice = sub_invoice
    @view = view
    @invoice=Invoice.find(@sub_invoice.invoice_id)
    @client=Client.find_by_id(@invoice.client_id)
    @tax_rate=@invoice.tax_rate
    @comment=@sub_invoice.comment
    if @invoice.total==nil
      @total=0
    else
      @total= @invoice.total
    end
    hash=Hash.new
    i=0
    while i<@invoice.list.length do
      hash.merge!({i => @invoice.list[i]})
      i=i+1
    end
    @invoice_list=Array.new
    hash.keys.each do |j|
        tot=precision(hash[j][2].to_d*hash[j][3].to_d)
        @invoice_list << [hash[j][0],hash[j][2],number_to_euro(hash[j][3].to_d),
        number_to_euro(tot)]
    end
    @lmax=@invoice_list.length
    if @sub_invoice.total!=nil
      @si_pourc_paid=(100 * @sub_invoice.total.to_d / (@total.to_d*(1+@tax_rate.to_d))).to_i
    else
      @si_pourc_paid=0
    end
    logo
    objet
    invoice_details
    invoice_total
    invoice_cond
    invoice_sign
    repeat :all do
      #Create a bounding box and move it up 18 units from the bottom boundry of the page
      bounding_box [bounds.left, bounds.bottom + 8], width: bounds.width do
        text "Société ADRIEN BIDINOT dommiciliée au 27 RUE RENE BRUN à YERRES (91330) - RCS: 792 752 172", size: 8, align: :center
      end
      bounding_box([bounds.right - 30,bounds.bottom], :width => 60, :height => 20) do
        count = page_count
        text "Page #{count}", size: 8
      end
    end

  end

  def logo
    logopath =  "#{Rails.root}/app/assets/images/logoabidinot.PNG"
    image logopath, :width => 75, :height => 75
    move_up 40
    text "Société ADRIEN BIDINOT 
    27 rue René BRUN
    91330 Yerres
    Tel: 06 87 04 79 50
    Email: ad-bidinot@hotmail.fr",
    :indent_paragraphs => 80

    move_down 40

    text "#{@client.first_name.capitalize} #{@client.last_name.capitalize} 
    #{@client.address}
    #{@client.postal_code} #{@client.city.capitalize}",
    :indent_paragraphs => 370

    move_down 20

    text "Facture # #{@sub_invoice.id}", 
    :indent_paragraphs => 40, size: 22
  end

  def objet
    move_down 20
    text "Date: #{Time.now.strftime("%d/%m/%Y")} ",
    :indent_paragraphs => 40  
    text "Objet: #{@sub_invoice.title}",
    :indent_paragraphs => 40
    if @invoice.quote_id != nil 
      @quote= Quote.find(@invoice.quote_id)
      if @quote.starttime !=nil
      text "Référence: devis #{@quote.title} envoyé le #{(@quote.starttime).strftime("%d/%m/%Y")}",
      :indent_paragraphs => 40
      end
    end
  end

  def invoice_details
    move_down 40
    table invoice_data, :width => 540, :cell_style => { size: 8 }do
      cells.borders = []
      row(0).borders = [:bottom]
      row(0).border_width = 2
      columns(1).align= :center
      columns(2..3).align = :right
      style row(0), :size => 13
      rows(1..@lmax.to_i).borders = [:bottom]
      rows(1..@lmax.to_i).border_width = 0.05
      self.header = true
      self.column_widths = {0 => 200, 1 => 80, 2 => 130, 3 => 130}
    end
  end

  
  def invoice_data

    [["Description", "Quantité", "PUHT", "PTHT"]] + @invoice_list
  end

  def invoice_total_data
    [["Total hors taxes", number_to_euro(@total.to_d)],
    ["TVA = #{(@tax_rate*100).to_s}%",number_to_euro(@total.to_d*@tax_rate)],
    ["Total toutes taxes comprises",number_to_euro(@total.to_d*(1+@tax_rate))],
    ["Echéance","#{@si_pourc_paid} %"],
    ["Total TTC à payer",number_to_euro(@sub_invoice.total.to_d)],
    ]

  end

  def precision(num)

    @view.number_with_precision(num, :precision => 2)
  end

  def invoice_total
    move_down 20
    table invoice_total_data, :position => :right, :width => 300 do
      cells.borders = []
      columns(1).align = :right
      self.column_widths = {0 => 200, 1 => 100}
    end
  end


  def invoice_cond
    move_down 50
    if @comment !=""
      text "Commentaire sur la facture:",:indent_paragraphs => 40, :size => 8
      text @comment,:indent_paragraphs => 40, :size => 8
      move_down 20
    end
    text "Conditions de règlement: Payable à #{@sub_invoice.echeance} jours date de facture" ,:indent_paragraphs => 40 , style:  :bold, :size => 8

    move_down 5
    text "Date d'échéance de paiement: #{(@sub_invoice.endtime).strftime("%d/%m/%Y")}",
    :indent_paragraphs => 40, style:  :bold, :size => 8

    move_down 5
    text "Pénalités de retard: 3 fois le taux d'intérêt légal sur les sommes en cas de retard de paiement (Loi #2008-776 du 04/08/08" ,:indent_paragraphs => 40 , style:  :bold, :size => 8


  end

  def invoice_sign
  move_down 20
      text "En votre aimable règlement, ",
      :indent_paragraphs => 250  

  end


def number_to_euro(amount)
  number_to_currency(amount,:unit=>'€', :separator => ",", :delimiter => " ", format: "%n %u")
end

end