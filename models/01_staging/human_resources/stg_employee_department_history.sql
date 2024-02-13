with employeedepartmenthistory as (
    select * from {{ source('aw_humanresources','employeedepartmenthistory')}}

),

final as (
    select 
      businessentityid as business_entity_id,
      businessentityid || '~' || departmentid as employee_department_history_sk,
      departmentid as department_id,
      shiftid as shift_id,
      startdate as start_date,
      enddate as end_date,
      modifieddate as last_update
    from employeedepartmenthistory
)

select * from final