require 'json'

class UsersController < Sinatra::Base
  before do
    content_type :json
  end

  # Listar todos os usuários
  get '/users' do
    users = User.all
    users.to_json(only: [:id, :name, :username, :email, :created_at])
  end

  # Mostrar um usuário específico
  get '/users/:id' do
    user = User.find_by(id: params[:id])
    halt 404, { error: "Usuário não encontrado" }.to_json unless user
    user.to_json(only: [:id, :name, :username, :email, :created_at])
  end

  # Criar um novo usuário
  post '/users' do
    data = JSON.parse(request.body.read)
    user = User.new(
      name: data["name"],
      username: data["username"],
      email: data["email"],
      password: data["password"],
      password_confirmation: data["password_confirmation"]
    )

    if user.save
      status 201
      user.to_json(only: [:id, :name, :username, :email, :created_at])
    else
      status 422
      { errors: user.errors.full_messages }.to_json
    end
  end

  # Atualizar um usuário existente
  put '/users/:id' do
    user = User.find_by(id: params[:id])
    halt 404, { error: "Usuário não encontrado" }.to_json unless user

    data = JSON.parse(request.body.read)
    if user.update(
      name: data["name"],
      username: data["username"],
      email: data["email"],
      password: data["password"],               # opcional
      password_confirmation: data["password_confirmation"]
    )
      user.to_json(only: [:id, :name, :username, :email, :created_at])
    else
      status 422
      { errors: user.errors.full_messages }.to_json
    end
  end

  # Deletar um usuário
  delete '/users/:id' do
    user = User.find_by(id: params[:id])
    halt 404, { error: "Usuário não encontrado" }.to_json unless user
    user.destroy
    { message: "Usuário deletado com sucesso" }.to_json
  end
end
