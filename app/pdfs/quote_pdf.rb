class QuotePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(quote, view)
    super()
    @quote = quote
    @view = view
    if @quote.total==nil
      @total=0
    else
      @total= @quote.total
    end
    @comment=@quote.comment
    @tax_rate=@quote.tax_rate.to_d
    @client=Client.find_by_id(@quote.client_id)
    hash=Hash.new
    i=0
    while i<@quote.list.length do
      hash.merge!({i => @quote.list[i]})
      i=i+1
    end
    @quote_list=Array.new
    hash.keys.each do |j|
        tot=precision(hash[j][2].to_d*hash[j][3].to_d)
        @quote_list << [hash[j][0],hash[j][2],number_to_euro(hash[j][3].to_d),
        number_to_euro(tot)]
    end
    @lmax=@quote_list.length
    logo
    objet
    quote_details
    quote_total
    quote_cond
    quote_sign
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

    text "Devis", 
    :indent_paragraphs => 40, size: 22
  end

  def objet
    move_down 20
    text "Date: #{Time.now.strftime("%d/%m/%Y")} ",
    :indent_paragraphs => 40  
    text "Objet: #{@quote.title}",
    :indent_paragraphs => 40

  end

  def quote_details
    move_down 40
    table quote_data, :width => 540, :cell_style => { size: 8 }do
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

  
  def quote_data

    [["Description", "Quantité", "PUHT", "PTHT"]] + @quote_list
  end

  def quote_total_data
    [["Total hors taxes", number_to_euro(@total.to_d)],
    ["TVA = #{(@tax_rate*100).to_s}%",number_to_euro(@total.to_d*@tax_rate)],
    ["Total toutes taxes comprises",number_to_euro(@total.to_d*(1+@tax_rate))]]

  end

  def precision(num)

    @view.number_with_precision(num, :precision => 2)
  end

  def quote_total
    move_down 20
    table quote_total_data, :position => :right, :width => 300 do
      cells.borders = []
      columns(1).align = :right
      self.column_widths = {0 => 200, 1 => 100}
    end
  end


  def quote_cond
    move_down 50
    if @comment !=""
      text "Commentaire sur le devis:",:indent_paragraphs => 40, :size => 8
      text @comment,:indent_paragraphs => 40, :size => 8
      move_down 20
    end
    text "Conditions de règlement:" ,:indent_paragraphs => 40 , style:  :bold, :size => 8
    text "- 50% à la commande
    - 20% au démarrage du chantier
    - Solde fin de chantier à réception de la facture" ,:indent_paragraphs => 100, :size => 8

    move_down 5
    text "Non compris dans notre proposition :
         - Tous travaux non clairement décrits dans notre offre,
         - Toute fourniture non clairement décrite dans notre offre,
         - Le non-respect des conditions de règlement annulera notre intervention",
    :indent_paragraphs => 40, style:  :bold, :size => 8
  end

  def quote_sign
  move_down 20
      text "Signature précédée de la mention 'Bon pour accord' ",
      :indent_paragraphs => 250  

  end


def number_to_euro(amount)
  number_to_currency(amount,:unit=>'€', :separator => ",", :delimiter => " ", format: "%n %u")
end

end