class Quote < ActiveRecord::Base

serialize :list
belongs_to :client, :class_name => "Client"
		
end
