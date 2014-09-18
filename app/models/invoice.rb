class Invoice < ActiveRecord::Base

serialize :list
belongs_to :customer

end
