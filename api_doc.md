# Documentação da API de Projetos

Abaixo, uma descrição dos endpoints disponíveis.

## 1. Listar Todas os Projetos

### Endpoint
```shell
GET /api/v1/projects
```

Retorna a lista de todos os projetos cadastradas.

```json
[
  {
    "id": 1,
    "title": "Projeto Master",
    "description": "Principal projeto criado",
    "category": "Video"
  },
  {
    "id": 2,
    "title": "Projeto Website",
    "description": "Um site de jogos",
    "category": "Programação"
  }
]
```

## Observações Gerais
- Todos os endpoints retornam dados no formato JSON.
- Em caso de sucesso, a resposta terá o código 200. 
- Em caso de erro, o código e uma mensagem explicativa serão retornados.