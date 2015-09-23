require 'bcrypt'

class User
  include DataMapper::Resource

  attr_reader :password

  property :id, Serial
  property :email, String
  property :password_digest, Text

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end
end
