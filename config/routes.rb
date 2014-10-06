Rails.application.routes.draw do
  devise_for :users
  resources :invoices

  resources :quotes
  resources :clients

  resources :devis
  get '/modify_client' => 'application#modify_client'
  get '/visu_pdf/quote_visu' => 'visu_pdf#quote_visu'
  put '/visu_pdf/quote_send' => 'visu_pdf#quote_send'
  put '/visu_pdf/sub_invoice_send' => 'visu_pdf#sub_invoice_send'
  get '/quotes/:id/invoice' => 'quotes#invoice'
  put '/quotes/:id/status' => 'quotes#status'
  get '/new_invoice' => 'invoices#new_invoice'
  put '/sub_inv_create/:id' => 'sub_invoice#create'
  put 'sub_invoice_mark_paid/:id' => 'sub_invoice#mark_paid'
  put 'sub_invoice_mark_unpaid/:id' => 'sub_invoice#mark_unpaid'
  delete '/sub_invoice/:id' => 'sub_invoice#delete'
  get '/visu_pdf/sub_invoice_visu' => 'visu_pdf#sub_invoice_visu'
  get '/report' => 'visu_pdf#report'
  

  

  root 'quotes#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
