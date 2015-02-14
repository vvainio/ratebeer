class Place
  include ActiveModel::Model

  attr_accessor :id, :name, :status, :reviewlink, :proxylink, :blogmap, :street,
                :city, :state, :zip, :country, :phone, :overall, :imagecount
end
