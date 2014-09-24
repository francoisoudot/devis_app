class Invoice < ActiveRecord::Base
belongs_to :customer
has_many :sub_invoices, dependent: :destroy

serialize :list


end
