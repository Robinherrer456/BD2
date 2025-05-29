-- Migrations will appear here as you chat with AI

create table secciones (
  id bigint primary key generated always as identity,
  nombre text not null
);

create table capitulos (
  id bigint primary key generated always as identity,
  numero text not null,
  descripcion text not null,
  seccion_id bigint references secciones (id)
);

create table partidas (
  id bigint primary key generated always as identity,
  codigo text not null,
  descripcion text not null,
  capitulo_id bigint references capitulos (id)
);

create table subpartidas (
  id bigint primary key generated always as identity,
  codigo text not null,
  descripcion text not null,
  partida_id bigint references partidas (id)
);

create table partidas_arancelarias (
  id bigint primary key generated always as identity,
  codigo text not null,
  descripcion text not null,
  subpartida_id bigint references subpartidas (id)
);