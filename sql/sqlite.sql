create table url_list (
    id        int primary key
   ,title     text not null
   ,url       text not null
   ,parent_id int
   ,type      text not null
);
