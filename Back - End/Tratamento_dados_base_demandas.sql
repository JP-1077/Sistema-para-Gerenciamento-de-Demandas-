
--=========================================================================================================================================
/*
DESENVOLVEDOR: João Pedro Mendes Fonseca
Objetivo: 
* Realização de tratativa nos dados da tabela TB_DEMANDAS_DETAIL utilizando métodos de manipulação de texto atráves da linugagem SQL. 
* Certamente, com isso a base está mais limpa, normalizada e padronizada facilitando assim o entendimento dos usuários no sistema final.
Paramêtros utilizados:
	* SUBSTRING: Extrai uma parte de uma string
	* CHARINDEX: Retorna a posição de uma substring dentro de uma string
	* REPLACE: Substitui todas as ocorrências de uma substring por outra
*/
--=========================================================================================================================================

SELECT
	nome_da_tarefa AS Nome_Tarefa,
	nome_do_bucket AS Nome_Bucket,
	progresso AS Status,
	prioridade AS Criticidade,
	atribuido_a AS Responsável,
	dt_criacao AS Data_Criação,

    -- Extração de KPI (considera KPI: e KPIs:)
    LTRIM(RTRIM(
        CASE
            WHEN CHARINDEX('KPI:', REPLACE(UPPER(t.itens_da_lista_de_verificacao), 'KPIS:', 'KPI:')) > 0 THEN
                SUBSTRING(
                    REPLACE(UPPER(t.itens_da_lista_de_verificacao), 'KPIS:', 'KPI:'),
                    CHARINDEX('KPI:', REPLACE(UPPER(t.itens_da_lista_de_verificacao), 'KPIS:', 'KPI:')) + LEN('KPI:'),
                    CHARINDEX(';', REPLACE(UPPER(t.itens_da_lista_de_verificacao), 'KPIS:', 'KPI:') + ';', CHARINDEX('KPI:', REPLACE(UPPER(t.itens_da_lista_de_verificacao), 'KPIS:', 'KPI:')) + LEN('KPI:'))
                        - (CHARINDEX('KPI:', REPLACE(UPPER(t.itens_da_lista_de_verificacao), 'KPIS:', 'KPI:')) + LEN('KPI:'))
                )
            ELSE
                'Não possui KPI Impactado'
        END
    )) AS KPI_Impactado,


    -- Formatação no campo de descrição
    LTRIM(RTRIM(
        CASE
            WHEN CHARINDEX('Descrição Detalhada:', t.descricao) > 0 AND CHARINDEX('Prioridade:', t.descricao) > 0 THEN
                SUBSTRING(
                    t.descricao,
                    CHARINDEX('Descrição Detalhada:', t.descricao) + LEN('Descrição Detalhada:'),
                    CHARINDEX('Prioridade:', t.descricao) - (CHARINDEX('Descrição Detalhada:', t.descricao) + LEN('Descrição Detalhada:'))
                )
            ELSE
                t.descricao
        END
    )) AS Descricao_Simplificada,


    -- Formatação dos rótulos
    REPLACE(t.rotulos, ';', ' e ') AS Rótulos,


    -- Formatação das Datas
    ISNULL(CONVERT(varchar, dt_inicio, 103), 'Demanda Não Iniciada') AS Data_Inicio,
    ISNULL(CONVERT(varchar, dt_prazo, 103), 'Prazo ainda não determinado') AS Data_Prazo,
    ISNULL(CONVERT(varchar, dt_conclusao, 103), 'Demanda ainda não concluída') AS Data_Conclusão

FROM 
    [Data_reports].[TB_DEMANDAS_DETAIL] AS t
WHERE 
    t.dt_criacao >= '2025-04-24'
order by dt_criacao DESC