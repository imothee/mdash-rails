Mdash::Engine.routes.draw do
  get "announce" => "announce#index"
  get "stats" => "stats#index"
end
