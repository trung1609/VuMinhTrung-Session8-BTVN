create table gioi2.products
(
    id               serial primary key,
    name             varchar(100),
    price            numeric,
    discount_percent int
);

insert into gioi2.products (name, price, discount_percent)
values ('San pham A', 1000, 50),
       ('San pham B', 2000, 25),
       ('San pham C', 1500, 15),
       ('San pham D', 3000, 60);

create or replace procedure calculate_discount(
    p_id int,
    out p_final_price numeric
)
    language plpgsql
as
$$
declare
    p_price    numeric;
    p_discount int;
begin
    select p.price, p.discount_percent into p_price, p_discount from gioi2.products p where p.id = p_id;
    p_discount := case
                      when p_discount > 50 then 50
                      else p_discount
        end;
    p_final_price := p_price - (p_price * p_discount / 100);
    update gioi2.products
    set price = p_final_price
    where id = p_id;

end;
$$;

do
$$
    declare
        p_final numeric(10, 2);
    begin
        call calculate_discount(2, p_final);
        raise notice 'Gia san pham sau khi giam gia: %', p_final;
    end;
$$


