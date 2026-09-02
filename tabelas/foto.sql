/*
 * Tabela: foto
 *
 * Descrição:
 * Armazena as URLs das fotos associadas a diferentes entidades
 * do sistema, como problemas, ocorrências, ordens de serviço,
 * observações de conclusão ou usuários.
 *
 * Dependências:
 * - problema
 * - ocorrencia
 * - ordem_servico
 * - observacao_conclusao
 * - usuario
 */

CREATE TABLE foto(
    id                      SERIAL PRIMARY KEY,
    problema_id             INTEGER REFERENCES problema(id),
    ocorrencia_id           INTEGER REFERENCES ocorrencia(id),
    ordem_servico_id        INTEGER REFERENCES ordem_servico(id),
    observacao_conclusao_id INTEGER REFERENCES observacao_conclusao(id),
    usuario_id              INTEGER REFERENCES usuario(id),
    url                     VARCHAR(255) NOT NULL,
    esta_ativo              BOOLEAN NOT NULL DEFAULT TRUE,
    data_criacao            TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT ck_foto_apenas_uma_fk
        CHECK (
            (CASE WHEN problema_id             IS NOT NULL THEN 1 ELSE 0 END) +
            (CASE WHEN ocorrencia_id           IS NOT NULL THEN 1 ELSE 0 END) +
            (CASE WHEN ordem_servico_id        IS NOT NULL THEN 1 ELSE 0 END) +
            (CASE WHEN observacao_conclusao_id IS NOT NULL THEN 1 ELSE 0 END) +
            (CASE WHEN usuario_id              IS NOT NULL THEN 1 ELSE 0 END)
            = 1
        )
);
