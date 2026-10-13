/**
 * Tabela: dim_tempo
 *
 * Descrição:
 * Disponibiliza informações de calendário utilizadas
 * nas análises temporais do BI.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE OR REPLACE VIEW dim_tempo AS
SELECT
    TO_CHAR(data, 'YYYYMMDD')::INTEGER AS data_id,
    data::DATE AS data,
    EXTRACT(DAY FROM data)::INTEGER AS dia,
    EXTRACT(MONTH FROM data)::INTEGER AS mes,
    CASE EXTRACT(MONTH FROM data)::INTEGER
        WHEN 1 THEN 'Janeiro'
        WHEN 2 THEN 'Fevereiro'
        WHEN 3 THEN 'Março'
        WHEN 4 THEN 'Abril'
        WHEN 5 THEN 'Maio'
        WHEN 6 THEN 'Junho'
        WHEN 7 THEN 'Julho'
        WHEN 8 THEN 'Agosto'
        WHEN 9 THEN 'Setembro'
        WHEN 10 THEN 'Outubro'
        WHEN 11 THEN 'Novembro'
        WHEN 12 THEN 'Dezembro'
    END AS nome_mes,
    EXTRACT(QUARTER FROM data)::INTEGER AS trimestre,
    EXTRACT(YEAR FROM data)::INTEGER AS ano,
    CASE EXTRACT(ISODOW FROM data)::INTEGER
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END AS dia_semana
FROM generate_series(
    '2025-01-01'::DATE,
    (CURRENT_DATE + INTERVAL '5 years')::DATE,
    INTERVAL '1 day'
) AS calendario(data);
