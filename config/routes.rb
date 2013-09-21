Assignment3::Application.routes.draw do
  get "converters/index"
  get "converters/convert", defaults: { format: 'json' }

  root "converters#index"
end
