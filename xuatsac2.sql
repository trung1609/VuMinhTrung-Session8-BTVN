create or replace procedure xuatsac2.calculate_bonus(
    p_emp_id int,
    p_percent numeric(10, 2),
    out p_bonus numeric(10, 2)
)
    language plpgsql
as
$$
declare
    p_salary numeric(10, 2);
begin
    select salary into p_salary from xuatsac1.employees where id = p_emp_id;
    if not FOUND then
        raise exception 'Employee not found id: %', p_emp_id;
    end if;

    p_percent := case
                     when p_percent <= 0 then 0
                     else
                         p_percent
        end;
    p_bonus := p_salary * (p_percent / 100);

    update xuatsac1.employees
    set bonus = p_bonus
    where id = p_emp_id;
end;
$$;

do
$$
    declare
        p_bonus_out numeric(10, 2);
    begin
        call xuatsac2.calculate_bonus(3, 15, p_bonus_out);
        raise notice 'Gia tri thuong la: %', p_bonus_out;
    end;
$$