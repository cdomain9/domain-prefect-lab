with employeedepartmenthistory as (
    select * from {{ ref('fact_employee_department_history')}}
) ,
dim_date as (

    select * from {{ ref('dim_date')}}
) ,

dim_employee as (

    select * from {{ ref('dim_employee')}}
) ,

dim_person as (

    select * from {{ ref('dim_person')}}
) ,

dim_department as (

    select * from {{ ref('dim_department')}}
),

dim_address as (

    select * from {{ ref('dim_address')}}
),

dim_shift as (

    select * from {{ ref('dim_shift')}}
),

final as (

    select

            edh.*,
            {{ dbt_utils.star(from=ref('dim_address'), relation_alias = 'a', except = ["business_entity_id"])}},
            {{ dbt_utils.star(from=ref('dim_employee'), relation_alias = 'e', except = ["business_entity_id", "business_key", "national_id_number", "org_node", "org_level", "employee_vacation_hours", "employee_sick_leave_hours", "row_guid", "last_update"])}},
            {{ dbt_utils.star(from=ref('dim_shift'), relation_alias = 's', except = ["shift_id", "shift_start_time", "shift_end_time", "last_update"])}},
            {{ dbt_utils.star(from=ref('dim_department'), relation_alias = 'd', except = ["department_id", "last_update"])}},
            {{ dbt_utils.star(from=ref('dim_person'), relation_alias = 'p', except = ["business_entity_id", "title", "first_name", "last_name", "row_guid", "last_update"])}}
    from employeedepartmenthistory edh

    left join dim_address a on a.business_entity_id = edh.business_entity_id
    left join dim_employee e on e.employee_id = edh.business_entity_id
    left join dim_shift s on s.shift_id = edh.shift_id
    left join dim_department d on d.department_id = edh.department_id
    left join dim_person p on p.business_entity_id = edh.business_entity_id

)

select * from final