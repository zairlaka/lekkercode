class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :archive
end
