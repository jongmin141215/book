require_relative '../../app/data_mapper_setup'

feature 'Viewing links' do

  scenario 'I can see existing links on the link page' do
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')

    visit '/links'

    expect(page.status_code).to eq 200

    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end

  end

  scenario 'I can press button create link' do
    visit '/links'
    click_button('Create link')
    expect(current_path).to eq '/links/new'
  end

end
