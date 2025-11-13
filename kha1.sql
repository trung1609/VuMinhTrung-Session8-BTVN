create table kha1.order_detail(
    id serial primary key ,
    order_id int,
    product_name varchar(100),
    quantity int,
    unit_price numeric
);

insert into kha1.order_detail (order_id, product_name, quantity, unit_price) values
                                                                                 (1,'San pham A',3,100),
                                                                                 (2,'San pham B',2,400),
                                                                                 (3,'San pham C',4,230),
                                                                                 (4,'San pham D',5,140);

create or replace procedure calculate_order_total(
    order_id_input int,
    out total numeric
)
language plpgsql
as $$
begin
    select sum(unit_price) into total from kha1.order_detail od where od.id = order_id_input;
end;
$$;

do $$
declare total_out numeric;
begin
    call calculate_order_total(2,total_out);
    raise notice 'Tong so don hang cua ma don hang la: %', total_out;
end;
$$



