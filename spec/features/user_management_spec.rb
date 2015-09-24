require_relative '../../app/data_mapper_setup'

feature 'User sign up' do

  # scenario 'I can sign up as a new user' do
  #   user = create :user
  #   expect { sign_up_as(user) }.to change(User, :count).by(1)
  #   expect(page).to have_content("Welcome, #{user.email}")
  #   expect(User.first.email).to eq('alice@example.com')
  # end
  #
  # scenario 'requires a matching confirmation password' do
  #   user = create :user
  #   user.password_confirmation = 'wrong'
  #   expect {sign_up_as(user)}.not_to change(User, :count)
  #   expect(current_path).to eq('/users')
  #   expect(page).to have_content 'Password and confirmation password do not match'
  # end
  #
  # scenario 'has not entered an email address' do
  #   user = create :user
  #   user.email = ''
  #   expect { sign_up_as(user) }.not_to change(User, :count)
  #   expect(current_path).to eq('/users')
  #   expect(page).to have_content 'Must enter an email address'
  # end

  scenario 'I cannot sign up with existing email' do
    user = create :user
    sign_up_as(user)
    user.password = 'wrong'
    expect{sign_up_as(user)}.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
    expect(page).to have_content('Password does not match the confirmation')
  end

  def sign_up_as(user)
    visit '/users/new'
    fill_in :email,    with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end

end
