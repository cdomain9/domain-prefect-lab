with addresstype as (
    select * from {{ source('aw_person','addresstype')}}

),

final as (
    select 
      addresstypeid as address_type_id,
      name as address_type,
      rowguid as row_guid,
      modifieddate as last_update

    from addresstype  
)

select * from final