# **Modelagem de Dados [Segundo Ano]**  
## **Padrões de Desenvolvimento**

Este documento apresenta os padrões de modelagem de banco de dados adotados no projeto. O objetivo é garantir **consistência**, **manutenção simplificada** e **legibilidade** para toda a equipe.

---

## **1. Nome das Entidades**

### **Regras**
1. Utilize nomes **no singular**.
2. Use apenas **letras minúsculas**.
3. **Evite abreviações**.

### **Por que seguir este padrão?**
- Em modelagens orientadas a objetos (POO), entidades representam objetos únicos, por isso o singular é mais intuitivo.
- Letras minúsculas e nomes completos evitam ambiguidades e melhoram a leitura.

| **Correto** | **Incorreto**       |
|-------------|---------------------|
| `usuario`   | `usuarios`, `tbl_usuario` |
| `endereco`  | `Endereco`, `end`   |

---

## **2. Nome dos Campos**

### **Regras**
1. Utilize o formato **snake_case**.
2. Evite nomes compostos em formatos como `camelCase`.

### **Por que seguir este padrão?**
- O PostgreSQL converte identificadores sem aspas para letras minúsculas, e o `snake_case` melhora a leitura de nomes compostos.

| **Correto**         | **Incorreto**      |
|---------------------|--------------------|
| `endereco_completo` | `enderecoCompleto` |
| `data_criacao`      | `dataCriacao`      |

---

## **3. Caracteres Permitidos**

### **Regras**
1. Utilize apenas **letras minúsculas**.
2. Não use **caracteres especiais** ou **acentos**.

| **Correto**    | **Incorreto**       |
|----------------|---------------------|
| `descricao`    | `Descrição`         |
| `numero_doc`   | `NúmeroDocumento`   |

---

## **4. Idioma**

- Todo o banco de dados deve ser escrito em **português** (tabelas, colunas, constraints e índices).

---

## **5. Nome das Colunas**

### **Regras**
1. Use **substantivos** simples e diretos.
2. Evite redundâncias.

| **Tabela**: `usuario` | **Correto** | **Incorreto**       |
|-----------------------|-------------|---------------------|
| Nome da coluna        | `nome`      | `usuario_nome`      |
| CPF                   | `cpf`       | `usuario_cpf`       |

---

## **6. Chaves Primárias**

### **Regra**
- Toda chave primária deve ser nomeada como **id**.

| **Tabela**: `usuario` | **Correto** | **Incorreto**       |
|-----------------------|-------------|---------------------|
| Chave primária        | `id`        | `usuario_id`        |

---

## **7. Chaves Estrangeiras**

### **Regra**
- Use o padrão: **nome_da_tabela_id**.

| **Tabela**: `endereco` | **Correto** | **Incorreto**       |
|------------------------|-------------|---------------------|
| Chave estrangeira      | `usuario_id` | `id_usuario`, `fk_usuario` |

---

## **8. Colunas de Tempo**

### **Regras**
1. Utilize nomes significativos.
2. Evite nomes genéricos como `data`.

| **Correto**         | **Incorreto** |
|---------------------|---------------|
| `data_criacao`      | `data`        |
| `data_atualizacao`  |               |

---

## **9. Colunas de Valor Lógico**

### **Regra**
- Nomeie campos booleanos como perguntas.

| **Pergunta**: O usuário está ativo? | **Correto** | **Incorreto** |
|-------------------------------------|-------------|---------------|
| Nome da coluna                      | `esta_ativo` | `ativo`       |

---

## **10. Tabelas de Relacionamento (N:N)**

### **Regra**
- Nomeie tabelas de ligação com os nomes das tabelas relacionadas, separados por **underline**.

| **Relacionamento** | **Correto**      | **Incorreto**       |
|--------------------|------------------|---------------------|
| `aluno` e `materia`| `aluno_materia`  | `aluno_materias`    |

---

## **11. Nomeação de Constraints e Índices**

### **Constraints**

| **Tipo**  | **Padrão**          | **Exemplo**         |
|-----------|---------------------|---------------------|
| UNIQUE    | `uk_tabela_coluna`  | `uk_usuario_cpf`    |
| CHECK     | `ck_tabela_regra`   | `ck_usuario_adulto` |

### **Índices**

| **Padrão**          | **Exemplo**         |
|---------------------|---------------------|
| `idx_tabela_coluna` | `idx_usuario_nome`  |

---

## **12. Tipos de Dados**

### **Princípios**
1. Escolha o tipo mais **específico e adequado**.
2. Evite limitações desnecessárias.

| **Campo**      | **Descrição**                     | **Tipo Correto** | **Tipo Incorreto** |
|-----------------|-----------------------------------|------------------|--------------------|
| `observacao`    | Observações gerais do pedido     | `TEXT`           | `VARCHAR(255)`     |

---

## **Dicas Finais**
1. **Consistência é chave**: siga os padrões para facilitar a colaboração.
2. **Documente decisões**: registre o motivo de escolhas específicas.
3. **Revisão periódica**: atualize a modelagem conforme o projeto evolui.

---