# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)




c1=Client.create(:email=>'francois.oudot@gmail.com', :first_name=>'francois', :last_name=>'oudot',:ln_fl=>'o', :address=>'92 rue des fontenelles', :city=>'Sevres', :postal_code=>'92310',:phone=>'510 283 1943')
c1=Client.create(:email=>'francois.oudot@gmail.com', :first_name=>'rancois', :last_name=>'udot',:ln_fl=>'u', :address=>'2 rue des pres', :city=>'Meudon', :postal_code=>'92345',:phone=>'51 1943')
c2=Client.create(:email=>'francois.oudot@gmail.com', :first_name=>'ncois', :last_name=>'udot',:ln_fl=>'u', :address=>'92 henry st', :city=>'San Francisco', :postal_code=>'94114',:phone=>'51 eer1943')


c1.quotes.create(:title => 'devis 1',:total => 1200,:status => 0,:tax_rate => 0.07,:list => [['plomberie','u',1,1200]])
c2.quotes.create(:title => 'devis 2',:total => 2400,:status => 1,:tax_rate => 0.2,:list => [['plomberie','u',1,1200],['menuiserie','u',1,1200]]  )
c1.quotes.create(:title => 'devis 3',:total => 3600,:status => 2,:comment=> 'dsnonsd f fdssdsdfsfd',:tax_rate => 0.07,:list => [['plomberie','u',1,1200],['menuiserie','u',1,1200],['maconnerie','u',1,1200]] )

