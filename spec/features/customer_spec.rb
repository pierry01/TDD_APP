require 'rails_helper'

RSpec.feature 'Customer', type: :feature do
  scenario 'Verifica link Cadastro de Clientes' do
    visit(root_path)
    expect(page).to have_link('Cadastro de Clientes')
  end
  
  scenario 'Verifica link Novo Cliente' do
    visit(root_path)
    click_on('Cadastro de Clientes')
    expect(page).to have_content('Listando Clientes')
    expect(page).to have_link('Novo Cliente')
  end

  scenario 'Verifica form Novo Cliente' do
    visit(customers_path)
    click_on('Novo Cliente')
    expect(page).to have_content('Novo Cliente')
  end
  
  scenario 'Cadastra um cliente' do
    visit(new_customer_path)
    customer_name = Faker::Name.name
    
    fill_in('Nome', with: customer_name)
    fill_in('Email', with: Faker::Internet.email)
    fill_in('Telefone', with: Faker::PhoneNumber.phone_number)
    attach_file('Foto do Perfil', "#{Rails.root}/spec/fixtures/avatar.png")
    choose(option: ['S', 'N'].sample)
    click_on('Criar Cliente')
    
    expect(page).to have_content('Cliente cadastrado com sucesso!')
    expect(Customer.last.name).to eq(customer_name)
  end
  
  scenario 'Não cadastra um cliente' do
    visit(new_customer_path)
    click_on('Criar Cliente')
    expect(page).to have_content('não pode ficar em branco')
  end
  
  scenario 'Mostra um cliente' do
    customer = create(:customer)
    
    visit(customer_path(customer.id))
    expect(page).to have_content(customer.name)
  end
  
  scenario 'Testando a Index' do
    2.times { create(:customer) }
    
    visit(customers_path)
    expect(page).to have_content(Customer.last.name)
    expect(page).to have_content(Customer.first.name)
  end
  
  scenario 'Atualiza um Cliente' do
    customer = create(:customer)
    
    new_name = 'NOME ALTERADO'
    visit(edit_customer_path(customer.id))
    fill_in('Nome', with: new_name)
    click_on('Atualizar Cliente')
    
    expect(page).to have_content('Cliente atualizado com sucesso!')
    expect(page).to have_content(new_name)
  end
  
  scenario 'Clica no link Mostrar da Index' do
    create(:customer)
    
    visit(customers_path)
    find(:xpath, '/html/body/table/tbody/tr[1]/td[2]/a').click
    expect(page).to have_content('Mostrando Cliente')
  end
  
  scenario 'Clica no link Editar da Index' do
    create(:customer)
    
    visit(customers_path)
    find(:xpath, '/html/body/table/tbody/tr[1]/td[3]/a').click
    expect(page).to have_content('Editando Cliente')
  end
  
  scenario 'Apaga um cliente' do
    create(:customer)
    
    visit(customers_path)
    find(:xpath, '/html/body/table/tbody/tr[1]/td[4]/a').click
    
    expect(page).to have_content('Cliente excluído com sucesso!')
  end
end
