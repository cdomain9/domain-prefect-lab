with department as (
    select 
      department_id,
      department_name,
      group_name,
      last_update
    from {{ref('stg_department')}}   
)

select * from department