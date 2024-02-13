with employee as (
    select
      employee_id,
      national_id_number,
      business_key,
      login_id,
      org_node,
      org_level,
      employee_job_title,
      employee_birth_date,
      employee_marital_status,
      employee_gender,
      employee_hire_date,
      employee_salaried_flag,
      employee_vacation_hours,
      employee_sick_leave_hours,
      employee_current_flag,
      row_guid,
      last_update
    from {{ ref('stg_employee')}}
    ),

person as (
    select
      business_entity_id,
      title,
      first_name,
      last_name
    from {{ref('stg_person')}}

    ),

final as (
    select
      p.title,
      p.first_name,
      p.last_name,
      e.employee_id,
      e.national_id_number,
      e.business_key,
      e.login_id,
      e.org_node,
      e.org_level,
      e.employee_job_title,
      e.employee_birth_date,
      e.employee_marital_status,
      e.employee_gender,
      e.employee_hire_date,
      e.employee_salaried_flag,
      e.employee_vacation_hours,
      e.employee_sick_leave_hours,
      e.employee_current_flag,
      e.row_guid,
      e.last_update

    from employee e
    left join person p on e.employee_id = p.business_entity_id
)

select * from final