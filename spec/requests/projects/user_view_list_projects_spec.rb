require 'rails_helper'

describe 'Usuário vê projetos' do
  it 'e deve estar autenticado' do
    get projects_path

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end
end
