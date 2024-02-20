class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :password

  # UserSerializer.new(*VARIABLE GOES HERE*).serializable_hash[:data][:attributes]
end
