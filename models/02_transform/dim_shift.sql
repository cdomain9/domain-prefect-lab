with shift as (
    select
      shift_id,
      shift_name,
      shift_start_time,
      shift_end_time,
      last_update
    from {{ref ('stg_shift') }}
)

select * from shift