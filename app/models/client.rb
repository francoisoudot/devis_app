class Client < ActiveRecord::Base
has_many :quotes, :class_name => "Quote", :foreign_key => "client_id", dependent: :destroy
has_many :invoices, dependent: :destroy
end
