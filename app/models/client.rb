class Client < ActiveRecord::Base
has_many :quotes, dependent: :destroy
has_many :invoices, dependent: :destroy
end
