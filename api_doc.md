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

## 1. Mudar status de um convite para cancelado

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
  "errors": ["Não é possível alterar convite que não está pendente."]
}
```

---

## Observações Gerais
- Todos os endpoints retornam dados no formato JSON.
- Em caso de sucesso, a resposta terá o código 200. 
- Em caso de erro, o código e uma mensagem explicativa serão retornados.