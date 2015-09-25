require_relative '../../app/data_mapper_setup'

feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    user = build :user
    user.email = 'bob@example.com'
    expect { sign_up_as(user) }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, bob@example.com")
  end

  scenario 'requires a matching confirmation password' do
    user = build :user
    user.password_confirmation = 'wrong'
    expect {sign_up_as(user)}.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'has not entered an email address' do
    user = build :user
    user.email = ''
    expect { sign_up_as(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Email must not be blank'
  end

  scenario 'I cannot sign up with existing email' do
    user = create :user
    user.password = 'wrong'
    expect{sign_up_as(user)}.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
    expect(page).to have_content('Password does not match the confirmation')
  end

end

feature 'User sign in' do

  let(:user) do
    User.create(email: 'user@example.com', password: 'secret1234',
               password_confirmation: 'secret1234')
  end

  scenario 'with correct credentials' do
    sign_in(email: user.email, password: user.password)
    expect(page).to have_content "Welcome, #{user.email}"
  end

end

feature 'User signs out' do

  let(:user) do
    User.create(email: 'test@test.com', password: '1234',
                password_confirmation: '1234')
  end

  scenario 'while being signed in' do
    sign_in(email: 'test@test.com', password: '1234')
    click_button 'Sign out'
    expect(page).to have_content('goodbye!')
    expect(page).not_to have_content('Welcome, test@test.com')
  end

end

feature 'Password reset' do
  scenario 'requesting a password reset' do
    user = User.create(email: 'test@test.com', password: '1234',
                password_confirmation: '1234')
    visit '/password_reset'
    fill_in 'Email', with: user.email
    click_button 'Reset password'
    user = User.first(email: user.email)
    expect(user.password_token).not_to be_nil
    expect(page).to have_content 'Check your emails'
  end
end
