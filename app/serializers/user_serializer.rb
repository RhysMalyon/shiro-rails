class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :last_name, :first_name_phonetic, :last_name_phonetic, :tel, :role

  # UserSerializer.new(*VARIABLE GOES HERE*).serializable_hash[:data][:attributes]
end
