with date_source as (

    select * from {{ ref ('date_details_source')}}

)

select * from date_source