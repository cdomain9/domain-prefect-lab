with employee as (
    select * from {{ source('aw_humanresources','employee')}}

),

final as (
    select 
      businessentityid as employee_id,
      nationalidnumber as national_id_number,
      loginid as business_key,
      loginid as login_id,
      organizationnode as org_node,
      organizationlevel as org_level,
      jobtitle as employee_job_title,
      birthdate as employee_birth_date,
      maritalstatus as employee_marital_status,
      gender as employee_gender,
      hiredate as employee_hire_date,
      salariedflag as employee_salaried_flag,
      vacationhours as employee_vacation_hours,
      sickleavehours as employee_sick_leave_hours,
      currentflag as employee_current_flag,
      rowguid as row_guid,
      modifieddate as last_update
    from employee
)

select * from final