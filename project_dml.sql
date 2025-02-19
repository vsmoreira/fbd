create table inep.participante as
	select
		me.nu_inscricao::bigint,
		me.nu_ano,
		me.tp_faixa_etaria,
		me.tp_sexo,
		me.tp_estado_civil,
		me.tp_cor_raca,
		me.tp_nacionalidade,
		me.tp_st_conclusao,
		me.tp_ano_concluiu,
		me.tp_escola,
		me.tp_ensino,
		me.in_treineiro > 0 as in_treineiro
	from
		inep.microdados_enem me;
alter table inep.participante add column id_participante bigserial primary key;
alter table inep.participante add unique (nu_inscricao, nu_ano);
alter table inep.participante add COLUMN id_escola integer;
alter table inep.participante add COLUMN id_local_prova integer;
alter table inep.participante add foreign key (id_escola) references inep.escola(id_escola);
alter table inep.participante add foreign key (id_local_prova) references inep.local_prova(id_local_prova);

create table inep.escola as
	select
	distinct
		me.co_municipio_esc,
		me.no_municipio_esc,
		me.co_uf_esc,
		me.tp_dependencia_adm_esc,
		me.tp_localizacao_esc,
		me.tp_sit_func_esc
	from
		microdados_enem me
	where
		me.co_municipio_esc is not null;

alter table inep.escola add column id_escola serial primary key;

create table inep.local_prova as
select
	distinct
		me.co_municipio_prova,
		me.no_municipio_prova,
		me.co_uf_prova,
		me.sg_uf_prova
	from
		microdados_enem me;
alter table inep.local_prova add column id_local_prova serial primary key;

update participante p set id_escola = e.id_escola 
	from
		microdados_enem me
	inner join 
		escola e on
		(e.co_municipio_esc = me.co_municipio_esc
			and e.co_uf_esc = me.co_uf_esc 
			and e.tp_dependencia_adm_esc = me.tp_dependencia_adm_esc
			and e.tp_localizacao_esc = me.tp_localizacao_esc
			and e.tp_sit_func_esc = me.tp_sit_func_esc )
 where
		(p.nu_inscricao = me.nu_inscricao::bigint
			and p.nu_ano = me.nu_ano);

update participante p set id_local_prova = e.id_local_prova   
	from
		microdados_enem me
	inner join 
		local_prova e on
		(e.co_municipio_prova = me.co_municipio_prova 
			and e.co_uf_prova = me.co_uf_prova
			and e.sg_uf_prova = me.sg_uf_prova)
	where
		(p.nu_inscricao = me.nu_inscricao::bigint
			and p.nu_ano = me.nu_ano);