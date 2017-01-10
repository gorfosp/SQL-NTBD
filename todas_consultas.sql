--Script utilizados para a criação de agregados e consultas das análises
-- ultimo Script referente a criação da tabela Fato


--Consulta para a Análise 1 SEM AGREGADO:
select uf_regiao, ano, uf_name, sum(al), rank() OVER (PARTITION BY uf_regiao, uf_name order by ano, sum(al) desc) 
from dim_local l 
inner join fato f on l.uf = f.id_uf
inner join dim_tempo t on t.id_tempo = f.id_tempo 
group by  uf_regiao, ano,  uf_name 
order by uf_regiao, ano, sum(al) desc
--Rank dos estados por região, em cada ano, por maior ocorrência de acidentes liquidados;(Medida holística) 


--Consulta SQL para a análise 2 SEM AGREGADO:
select ano, uf_regiao, quadrimestre, avg(obito) from dim_local l
inner join fato f on l.uf = f.id_uf
inner join dim_tempo t on t.id_tempo = f.id_tempo
where t.ano = 2000
group by ano, uf_regiao, quadrimestre
order by ano, uf_regiao, quadrimestre, avg(obito) 
--Média de óbitos por região em cada quadrimestre de 2000; (Medida algébrica)


--Consulta SQL para a análise 3 UTILIZANDO AGREGADO:


select ano, uf_nome, al, gcnae
from ano_uf_nome_gcnae_agregado
where ano = 2000 
group by ano, uf_nome, gcnae, al
order by  uf_nome,  al desc , gcnae 
--Análise de quais grupo de áreas de trabalho tiveram os maiores números de acidentes liquidados por estado, para um dado ano; (Medida distributiva)



--Agregado Ano, Regiao

select ano,uf_regiao, sum(obito), sum(al) from dim_local l
inner join fato f on l.uf = f.id_uf
inner join dim_tempo t on t.id_tempo = f.id_tempo
group by ano, uf_regiao
order by ano, uf_regiao



--Agregado Ano, Estado (uf_nome)

select ano, quadrimestre, uf_nome,  sum(obito) as obito, sum(al) as al from dim_local l 
inner join fato f on f.id_local = l.id_local
inner join dim_tempo t on f.id_tempo = t.id_tempo
group by ano, quadrimestre, uf_nome
order by ano, quadrimestre, uf_nome



--Agregado Ano, Gcnael Regiao

select ano, gcnael, uf_regiao, sum(obito) as obito, sum(al) as al from dim_tempo t
inner join fato f on f.id_tempo = t.id_tempo
inner join dim_local l on l.id_local = f.id_LOCAL
inner join dim_classificacao c on f.id_classificacao = c.id_classificacao
group by ano, gcnael, uf_regiao
order by ano, gcnael, uf_regiao


-- Ano Regiao Estado (uf_regiao, uf_estado)

select ano, uf_regiao ,uf_nome, sum(al) from dim_local l
inner join fato f on f.id_local = l.id_local
inner join dim_tempo t on t.id_tempo = f.id_tempo
group by ano, uf_regiao, uf_nome
order by ano, uf_regiao, sum(al) desc 



--Agregado Gcnae Regiao (uf_regiao)

select uf_regiao, gcnae ,sum(obito) as obito, sum(al) as al from dim_classificacao c
inner join fato f on f.id_classificacao = c.id_classificacao
inner join dim_local l on l.id_local = f.id_local
group by uf_regiao, gcnae
order by uf_regiao, gcnae



--Agregado Sigla Estado Cnae

select uf_sigla, uf_nome, cnae, sum(obito) as obito, sum(al) as al from dim_local l
inner join fato f on f.id_local = l.id_local
inner join dim_classificacao c on c.id_classificacao = f.id_classificacao
group by uf_sigla,uf_nome, cnae
order by uf_sigla, uf_nome, cnae


--Agregados referentes as análises

--Agregado Ano Regiao  Estado

select ano, uf_regiao ,uf_nome, sum(al) from dim_local l
inner join fato f on f.id_local = l.id_local
inner join dim_tempo t on t.id_tempo = f.id_tempo
group by ano, uf_regiao, uf_nome
order by ano, uf_regiao, sum(al) desc 



--Agregado Regiao Quadrimestre(auxiliar da análise 2)

select uf_regiao, quadrimestre, avg(obito) from dim_tempo t
inner join fato f on f.id_tempo = t.id_tempo
inner join dim_local l on l.id_local = f.id_local
group by uf_regiao, quadrimestre
order by uf_regiao, quadrimestre, avg(obito)



-- Agregado Ano Estado gcnae (auxiliar da análise 3)

select ano, uf_nome, gcnae, sum(al), sum(obito) from dim_classificacao c
inner join fato f on c.id_classificacao = f.id_classificacao
inner join dim_local l on f.id_local = l.id_local
inner join dim_tempo t on t.id_tempo = f.id_tempo
group by ano, uf_nome, gcnae
order by ano, uf_nome, gcnae





-- Script para a criaçao da tabela de Fato
select id_tempo, l.id_local , id_classificacao, obito, al from dim_tempo t
	inner join fonte_de_dados f on (t.ano = f.ano and t.quadrimestre = f.quadrimestre)
	inner join dim_classificacao c on (f.cnae = c.cnae and f.gcnae = c.gcnae and f.gcnael = c.gcnael)
	inner join dim_local l on (f.uf = l.id_local)
order by id_tempo, uf, id_classificacao

