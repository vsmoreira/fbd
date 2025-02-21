-- Active: 1740091055518@@localhost@5432@postgres@inep
-- Active: 1740091055518@@localhost@5432@fbd
select COUNT(*) from inep.participante;

-- 1. projetar total de participantes por tipo de escola excluindo-se os treineiros
select
	case tp_escola
		when 1 then 'Não respondeu'
		when 2 then 'Pública'
		when 3 then 'Privada'
		else 'Não informado'
	end as tipo_escola,
	COUNT(*) as quantidade
from
	participante
where
	not in_treineiro
group by
	tp_escola;

-- 2. Selecionar os 10 municípios com maior média de notas
with pontuacao_participante as (
    select
        p.id_participante,
        sum(coalesce(nu_nota,0)) as nota_final
    from
        participante p
        inner join resposta_participante rp on (rp.id_participante = p.id_participante)
    where
        rp.tp_presenca = 1
        and not p.in_treineiro
    group by
        p.id_participante
)
select
    e.no_municipio_esc,
    avg(pp.nota_final) as media_nota
from
	participante p
    inner join pontuacao_participante pp on (p.id_participante = pp.id_participante) 
    inner join escola e on (p.id_escola = e.id_escola)
group by
    e.no_municipio_esc
order by
    avg(pp.nota_final) desc
limit 10;

-- 3. projetar os locais de prova com maior índice de abstenção	
select
    lp.no_municipio_prova,
    lp.sg_uf_prova,
    count(*) as quantidade
from
    participante p
    inner join local_prova lp on (p.id_local_prova = lp.id_local_prova)
    inner join resposta_participante rp on (rp.id_participante = p.id_participante and rp.tp_prova = 'CN' and rp.tp_presenca = 0)
group by
    lp.no_municipio_prova,
    lp.sg_uf_prova
order by
    count(*) desc
limit 10;
