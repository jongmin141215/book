require_relative '../../app/models/user'

describe User do

  let!(:user) do
    User.create(email: 'test@test.com', password: '1234',
                password_confirmation: '1234')
  end

  it 'authenticates when given a valid email and password' do
    authenticated_user = User.authenticate(user.email, user.password)
    expect(authenticated_user).to eq user
  end

end