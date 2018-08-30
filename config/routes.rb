Rails.application.routes.draw do

  get 'payments/status', to: 'payments#status', defaults: { format: 'json' }
  post 'payments', to: 'payments#create', defaults: { format: 'json' }
  post 'recipients', to: 'recipients#add', defaults: { format: 'json' }

end
