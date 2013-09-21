Assignment3::Application.routes.draw do
  get "converters/index"
  get "converters/convert"

  root "converters#index"
end
