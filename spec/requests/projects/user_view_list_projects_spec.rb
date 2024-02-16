require 'rails_helper'

describe 'Usuário vê projetos' do
  it 'e deve estar autenticado' do
    get projects_path

    expect(response).to redirect_to home_path
  end
end
