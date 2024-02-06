# Documentação da API de Projetos

Abaixo, uma descrição dos endpoints disponíveis.

## 1. Listar Todas os Projetos

### Endpoint

```shell
GET /api/v1/projects
```

Retorna a lista de todos os projetos cadastradas. (Status: 200):

```json
[
  {
    "id": 1,
    "title": "Projeto Master",
    "description": "Principal projeto criado",
    "category": "Video",
    "project_job_categories": [
      {
        "job_category_id": 1
      },
      {
        "job_category_id": 2
      }
    ]
  },
  {
    "id": 2,
    "title": "Projeto Website",
    "description": "Um site de jogos",
    "category": "Programação",
    "project_job_categories": [
      {
        "job_category_id": 1
      },
      {
        "job_category_id": 2
      }
    ]
  }
]
```

Retorno esperado caso não tenham projetos cadastrados. (Status: 200):

```json
{
  "message": "Nenhum projeto encontrado."
}
```

### Erros tratados

Erro interno de servidor (Status: 500)

Retorno esperado:

```json
{ 
  "errors": ["Erro interno de servidor."]
}
```

---

## 2. Mudar status de um convite para cancelado

### Endpoint

```shell
PATCH /api/v1/invitations/:id
```
<br>

Retorno esperado caso a requisição seja bem sucedida. (Status: 200)

<br>

Retorno caso o convite não esteja mais pendente. (Status: 409)

```json
{ 
  "message": ["Não é possível alterar convite que não está pendente."]
}
```

  ### Erros tratados

Erro para objeto não encontrado (Status: 404)

```json
{ 
  "errors": ["Erro, não encontrado."]
}
```

---

## 3 Criar solicitação para participação em projetos

### Endpoint

```shell
GET /api/v1/proposals
```

#### Corpo da requisição:

A requisição requer o ID de um projeto existente na plataforma Cola?Bora!, o ID válido de um perfil da Portfoliorrr e uma mensagem opcional.

```json
{ 
  "proposal": 
    {
      "project_id": 1,
      "profile_id": 3,
      "email": "user@email.com",
      "message": "Gostaria de participar do projeto!",
    }
}
```

<br>

Retorno esperado caso a requisição seja bem sucedida. (Status: 201)

```json
{ 
  "data": 
    {
      "proposal_id": 1
    }
}
```

<br>



  ### Erros tratados

Retorno caso o projeto não exista na plataforma Cola?Bora!. (Status: 404)

```json
{ 
  "errors": ["Projeto não encontrado"]
}
```

Erros de ID de Perfil (Status: 409)

```json
// ID de perfil em branco
{ 
  "errors": ["ID de perfil não pode ficar em branco", "ID de Perfil não é um número"]
}

// ID de perfil menor ou igual a zero
{
  "errors": ["ID de Perfil deve ser maior ou igual a 1"]
}
```

Erros de Solicitação (Status: 409)

```json
// Usuário já tem solicitação pendente para o projeto
{ 
  "errors": ["Usuário já tem solicitação pendente para o projeto"]
}

// Usuário já é colaborador do projeto
{
  "errors": ["Usuário já faz parte deste projeto"]
}
```

Erro interno de servidor (Status: 500)

Retorno esperado:

```json
{ 
  "errors": ["Erro interno de servidor."]
}
```

---

## Observações Gerais
- Todos os endpoints retornam dados no formato JSON.
- Em caso de sucesso, a resposta terá o código 200. 
- Em caso de erro, o código e uma mensagem explicativa serão retornados.