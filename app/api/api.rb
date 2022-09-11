class API < Grape::API
  mount V1::Texter
end
