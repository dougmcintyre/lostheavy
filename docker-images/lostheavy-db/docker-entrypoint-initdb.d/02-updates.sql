\c lostheavy

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create table test (
    id bigserial not null primary key,
    name text not null unique
);

insert into test (name) values ('Doug McIntyre');
