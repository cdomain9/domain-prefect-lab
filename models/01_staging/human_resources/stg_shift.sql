with shift as (
    select * from {{ source('aw_humanresources','shift')}}
),

final as (
    select
      shiftid as shift_id,
      name as shift_name,
      starttime as shift_start_time,
      endtime as shift_end_time,
      modifieddate as last_update
    from shift
)

select * from final