/*
 domain tables
*/
create table tipo_dependencia_administrativa (
	cd_tipo_dep_adm integer primary key,
	descricao varchar(25) not null
);

insert into tipo_dependencia_administrativa (cd_tipo_dep_adm, descricao ) values
(1,	'Federal'),
(2,	'Estadual'),
(3,	'Municipal'),
(4,	'Privada');
create table tipo_faixa_etaria (
	cd_tipo integer primary key,
	descricao varchar(25) not null
);
insert into tipo_faixa_etaria values
	(1,	'Menor de 17 anos'),
	(2,	'17 anos'),
	(3,	'18 anos'),
	(4,	'19 anos'),
	(5,	'20 anos'),
	(6,	'21 anos'),
	(7,	'22 anos'),
	(8,	'23 anos'),
	(9,	'24 anos'),
	(10,	'25 anos'),
	(11,	'Entre 26 e 30 anos'),
	(12,	'Entre 31 e 35 anos'),
	(13,	'Entre 36 e 40 anos'),
	(14,	'Entre 41 e 45 anos'),
	(15,	'Entre 46 e 50 anos'),
	(16,	'Entre 51 e 55 anos'),
	(17,	'Entre 56 e 60 anos'),
	(18,	'Entre 61 e 65 anos'),
	(19,	'Entre 66 e 70 anos'),
	(20,	'Maior de 70 anos');

/**
 * business tables
 */
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

create table resposta_participante (
	id_resposta bigserial primary key,
	id_participante bigint not null,
	tp_prova char(2) not null,
	co_prova int null,
	tp_presenca int not null,
	nu_nota float null,
	tx_resposta varchar(50) null,
	tp_lingua int
);

/**
 * insert data
 */

insert into resposta_participante (id_participante, tp_prova, co_prova, tp_presenca, nu_nota, tx_resposta, tp_lingua)
	select
			p.id_participante,
			'CN' as tp_prova,
			me.co_prova_cn as co_prova,
			me.tp_presenca_cn as tp_presenca,
			me.nu_nota_cn as nu_nota,
			me.tx_respostas_cn as tx_resposta,
			-1 as tp_lingua
		from
			microdados_enem me
		inner join
			participante p on (p.nu_inscricao = me.nu_inscricao::bigint and p.nu_ano = me.nu_ano)
	
		union
			
		select
			p.id_participante,
			'CH' as tp_prova,
			me.co_prova_ch  as co_prova,
			me.tp_presenca_ch  as tp_presenca,
			me.nu_nota_ch  as nu_nota,
			me.tx_respostas_ch  as tx_respostas,
			-1 as tp_lingua
		from
			microdados_enem me
		inner join
			participante p on (p.nu_inscricao = me.nu_inscricao::bigint and p.nu_ano = me.nu_ano)
		
		union
			
		select
			p.id_participante,
			'LC' as tp_prova,
			me.co_prova_lc as co_prova,
			me.tp_presenca_lc as tp_presenca,
			me.nu_nota_lc   as nu_nota,
			me.tx_respostas_lc as tx_respostas,
			me.tp_lingua
		from
			microdados_enem me
		inner join
			participante p on (p.nu_inscricao = me.nu_inscricao::bigint and p.nu_ano = me.nu_ano)
			
		union
		
		select
			p.id_participante,
			'MT' as tp_prova,
			me.co_prova_mt as co_prova,
			me.tp_presenca_mt as tp_presenca,
			me.nu_nota_mt as nu_nota,
			me.tx_respostas_mt as tx_respostas,
			-1 as tp_lingua
		from
			microdados_enem me
		inner join
			participante p on (p.nu_inscricao = me.nu_inscricao::bigint and p.nu_ano = me.nu_ano)
;

/**
 * constraionts
 */
alter table inep.escola add foreign key (tp_dependencia_adm_esc) references tipo_dependencia_administrativa(cd_tipo_dep_adm);
alter table inep.participante add foreign key (id_escola) references inep.escola(id_escola);
alter table inep.participante add foreign key (id_local_prova) references inep.local_prova(id_local_prova);
alter table inep.resposta_participante add foreign key (id_participante) references inep.participante(id_participante);
alter table inep.resposta_participante add foreign key (co_prova) references inep.gabarito(co_prova);