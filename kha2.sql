create table kha2.inventory(
    product_id serial primary key ,
    product_name varchar(100),
    quantity int
);

insert into kha2.inventory(product_name, quantity) values
                                                       ('San pham A', 2),
                                                       ('San pham B', 3),
                                                       ('San pham C', 1);

create or replace procedure check_stock(
    p_id int,
    p_qty int
)
language plpgsql
as $$
begin
    if (select quantity from kha2.inventory where product_id = p_id) >= p_qty then
        raise notice 'Đủ hàng trong kho';
    else
        raise notice 'Không đủ hàng trong kho';
    end if;
end;
$$;

call check_stock(2,4);
call check_stock(1,2);



