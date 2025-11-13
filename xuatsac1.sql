create table xuatsac1.employees
(
    id         serial primary key,
    name       varchar(100) not null,
    department varchar(50),
    salary     numeric(10, 2),
    bonus      numeric(10, 2) default 0,
    status     varchar(20)
);

insert into xuatsac1.employees (name, department, salary, status)
VALUES ('Nguyen Van A', 'HR', 4000, null),
       ('Tran Thi B', 'IT', 6000, null),
       ('Le Van C', 'Finance', 10500, null),
       ('Pham Thi D', 'IT', 8000, null),
       ('Do Van E', 'HR', 12000, null);

create or replace procedure xuatsac1.update_employee_status(
    p_emp_id int,
    out p_status varchar(20)
)
    language plpgsql
as
$$
declare
    p_salary     numeric(10, 2);
    p_old_status varchar(20);
begin
    select salary, status into p_salary, p_old_status from xuatsac1.employees e where e.id = p_emp_id;

    --Kiem tra nhan vien co ton tai hay khong
    if not FOUND then
        raise notice 'Employee not found (id: %)',p_emp_id;
    end if;

    --Neu luong < 5000 cap nhat status = 'JUNIOR'
    --Nếu lương từ 5000–10000 → cập nhật status = 'Mid-level'
    --Nếu lương > 10000 → cập nhật status = 'Senior’
    p_status := case
                    when p_salary < 5000 then 'Junior'
                    when p_salary between 5000 and 10000 then 'Mid-level'
                    when p_salary > 10000 then 'Senior'
        end;

    update xuatsac1.employees
    set status = p_status
    where id = p_emp_id;
end;
$$;

do
$$
    declare
        p_status_out varchar(20);
    begin
        call xuatsac1.update_employee_status(6, p_status_out);
        raise notice 'Trang thai sau cap nhat la: %', p_status_out;
    end;
$$

