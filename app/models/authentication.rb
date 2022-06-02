class Authentication < ApplicationRecord
  belongs_to :user

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      provider = auth_hash.provider
      uid = auth_hash.uid

      auth = find_by(provider: provider, uid: uid.to_s)

      auth ? auth.user : build_user_from(auth_hash)
    end

    private

    def build_user_from(auth_hash)
      provider = auth_hash.provider
      uid = auth_hash.uid

      info = auth_hash.info
      name = info.name
      email = info.email

      user = User.create(name: name, email: email)
      user.authentications.create(provider: provider, uid: uid)

      user
    end
  end
end
