with employeedepartmenthistory as (

    select
      employee_department_history_sk,
      business_entity_id,
      department_id,
      shift_id,
      start_date,
      end_date,
      last_update
    from {{ref('stg_employee_department_history')}}
),
employee as (
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
    from {{ref ('stg_employee')}}

),
shift as (
    select
      shift_id,
      shift_name,
      shift_start_time,
      shift_end_time,
      last_update
    from {{ ref ('stg_shift')}}

    ),

final as (
    select
      ed.employee_department_history_sk,
      ed.business_entity_id,
      e.national_id_number,
      ed.department_id,
      ed.shift_id,
      ed.start_date,
      ed.end_date,
      e.org_node,
      e.org_level,
      e.employee_vacation_hours,
      e.employee_sick_leave_hours,
      s.shift_start_time,
      s.shift_end_time
    from employeedepartmenthistory ed
    left join employee e on e.employee_id = ed.business_entity_id
    left join shift s on s.shift_id = ed.shift_id
)

select * from final