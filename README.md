# 🎮 API - Love Letter (Ruby + Sinatra)

Esta é uma API desenvolvida em **Ruby** com **Sinatra** para gerenciar usuários e partidas do jogo **Love Letter**.

---

## 📌 Endpoints

### 👤 Usuários

#### 🔹 Listar todos os usuários
```http
GET /users

Resposta (200):

[
  {
    "id": 1,
    "name": "Gabriel",
    "username": "gabriel",
    "email": "gabriel@example.com",
    "created_at": "2025-09-29T22:00:00Z"
  }
]

🔹 Buscar usuário por ID

GET /users/:id

Resposta (200):

{
  "id": 1,
  "name": "Gabriel",
  "username": "gabriel",
  "email": "gabriel@example.com",
  "created_at": "2025-09-29T22:00:00Z"
}

🔹 Criar usuário

POST /users
Content-Type: application/json

Body:

{
  "name": "Gabriel",
  "username": "gabriel",
  "email": "gabriel@example.com",
  "password": "123456",
  "password_confirmation": "123456"
}

Resposta (201):

{
  "id": 2,
  "name": "Gabriel",
  "username": "gabriel",
  "email": "gabriel@example.com",
  "created_at": "2025-09-29T22:05:00Z"
}

🔹 Atualizar usuário

PUT /users/:id
Content-Type: application/json

Body:

{
  "name": "Gabriel Carlos",
  "email": "gabriel.carlos@example.com"
}

Resposta (200):

{
  "id": 1,
  "name": "Gabriel Carlos",
  "username": "gabriel",
  "email": "gabriel.carlos@example.com",
  "created_at": "2025-09-29T22:00:00Z"
}

🔹 Deletar usuário

DELETE /users/:id

Resposta (200):

{ "message": "Usuário deletado com sucesso" }

🏠 Salas e Jogo
🔹 Criar uma sala

POST /:room_id/create?username=jogador1

Resposta (200):

{
  "message": "Sala pronta para entrar",
  "room_id": "123",
  "username": "jogador1",
  "websocket_url": "ws://localhost:4567/game/123?username=jogador1"
}

🔹 Entrar em uma sala existente

POST /room/:room_id/join?username=jogador2

Resposta (200):

{
  "message": "Pronto para entrar na sala",
  "room_id": "123",
  "username": "jogador2",
  "websocket_url": "ws://localhost:4567/game/123?username=jogador2"
}

🔹 Listar salas

GET /rooms

Resposta (200):

{
  "rooms": [
    {
      "room_id": "123",
      "players": ["jogador1", "jogador2"]
    }
  ]
}

🔹 Iniciar jogo em uma sala

POST /:room_id/start

Resposta (200):

{ "message": "Jogo iniciado na sala 123" }

🔹 Comprar carta

POST /:room_id/draw/:username

Resposta (200):

{
  "message": "jogador1 comprou uma carta",
  "carta_comprada": { "name": "Padre", "value": 2 },
  "hand": [
    { "name": "Padre", "value": 2 },
    { "name": "Aia", "value": 4 }
  ]
}

🔹 Jogar carta

POST /:room_id/play/:username

Body (se a carta exigir alvo):

{
  "card_index": 0,
  "target_username": "jogador2",
  "guess": "Padre"   // só para carta Guarda
}

Resposta (200):

{
  "message": "jogador1 jogou a carta Padre",
  "efeito": null,
  "remaining_hand": ["Aia"]
}

🔹 Ver cartas de um jogador

GET /:username/:room_id/cards

Resposta (200):

{
  "hand": ["Padre", "Aia"]
}

🚀 Rodando o projeto

    Instale as dependências:

bundle install

    Execute o servidor:

ruby app.rb -p 4567

    API estará disponível em:

http://localhost:4567