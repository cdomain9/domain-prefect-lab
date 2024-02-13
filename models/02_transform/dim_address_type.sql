with addresstype as (
    select 
      address_type_id,
      address_type,
      row_guid,
      last_update
    from {{ ref('stg_address_type') }}  
)

select * from addresstype