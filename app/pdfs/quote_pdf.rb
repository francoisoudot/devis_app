class QuotePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(quote, view)
    super()
    @quote = quote
    @view = view
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
    logo
    objet
    quote_details
    quote_total
    quote_cond
  end

  def logo
    logopath =  "#{Rails.root}/app/assets/images/meta_icons/apple-touch-icon-57x57.png"
    image logopath, :width => 50, :height => 50
    move_up 40
    text "Société Flatty - Francois Oudot 
    92 Henry st 
    94114 San Francisco",
    :indent_paragraphs => 80

    move_down 20

    text "#{@client.first_name.capitalize} #{@client.last_name.capitalize} 
    #{@client.address}
    #{@client.postal_code} #{@client.city.capitalize}",
    :indent_paragraphs => 370

    move_down 40

    text "Devis", 
    :indent_paragraphs => 40, size: 22
  end

  def objet
    move_down 20
    text "Devis # #{@quote.id}",
    :indent_paragraphs => 40, :size => 13
    move_down 15
    text "Objet: #{@quote.title}",
    :indent_paragraphs => 40, :size => 13
  end

  def quote_details
    move_down 40
    table quote_data, :width => 540 do
      row(0).font_style = :bold
      columns(1).align= :center
      columns(2..3).align = :right
      self.header = true
      self.column_widths = {0 => 200, 1 => 80, 2 => 130, 3 => 130}
    end
  end

  
  def quote_data

    [["Description", "Quantité", "PUHT", "PTHT"]] + @quote_list
  end

  def quote_total_data
    [["Total hors taxes", number_to_euro(@quote.total.to_d)],
    ["TVA = #{(@tax_rate*100).to_s}%",number_to_euro(@quote.total.to_d*@tax_rate)],
    ["Total toutes taxes comprises",number_to_euro(@quote.total.to_d*(1+@tax_rate)) ]]

  end

  def precision(num)

    @view.number_with_precision(num, :precision => 2)
  end

  def quote_total
    move_down 10
    table quote_total_data, :position => :right, :width => 260 do
      columns(0).font_style = :bold
      columns(1).align = :right
      self.column_widths = {0 => 130, 1 => 130}
    end
  end


  def quote_cond
    move_down 50
    text "Conditions de règlement:" ,:indent_paragraphs => 40 , style:  :bold, :size => 13
    text "50% à la commande
    20% au démarrage du chantier
    Solde fin de chantier à réception de la facture" ,:indent_paragraphs => 100, :size => 13

    move_down 15
    text "Non compris dans notre proposition :
         Tous travaux non clairement décrits dans notre offre,
         Toute fourniture non clairement décrite dans notre offre,
         Le non-respect des conditions de règlement annulera notre intervention",
    :indent_paragraphs => 40, style:  :bold, :size => 13
  end

def number_to_euro(amount)
  number_to_currency(amount,:unit=>'€', :separator => ",", :delimiter => " ", format: "%n %u")
end

end