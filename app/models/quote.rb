class Quote < ActiveRecord::Base

serialize :list
belongs_to :customer
		
end
