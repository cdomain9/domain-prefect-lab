with department as (
  select * from {{ source('aw_humanresources', 'department') }}
),

final as (
  select
    departmentID as department_id,
    Name as department_name,
    groupname as group_name,
    ModifiedDate as last_update
  from department
)

select * from final