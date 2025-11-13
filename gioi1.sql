create table gioi1.employees
(
    emp_id    serial primary key,
    emp_name  varchar(100),
    job_level int,
    salary    numeric
);

insert into gioi1.employees (emp_name, job_level, salary)
values ('Trung', 3, 1000),
       ('Hung', 1, 500),
       ('Tung', 2, 700);

create or replace procedure adjust_salary(
    p_emp_id int,
    out p_new_salary numeric
)
    language plpgsql
as
$$
declare
    p_job_level int;
    p_old_salary numeric;
begin
    select job_level, salary into p_job_level, p_old_salary from gioi1.employees where emp_id = p_emp_id;
    if p_job_level = 1 then
        p_new_salary := p_old_salary *1.05;
    elsif p_job_level = 2 then
        p_new_salary := p_old_salary *1.1;
    elsif p_job_level = 3 then
        p_new_salary := p_old_salary *1.15;
    else
        p_new_salary := p_old_salary;
        raise notice 'Job level % không hợp lệ', p_job_level;
    end if;

    --Cap nhat lai luong
    update gioi1.employees
    set salary = p_new_salary
    where emp_id = p_emp_id;
end;
$$;

do $$
declare new_salary numeric;
begin
    call adjust_salary(2,new_salary);
    raise notice 'Lương sau khi cập nhật: %', new_salary;
end;
$$
