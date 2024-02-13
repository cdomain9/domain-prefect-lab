with businessentityaddress as (
    select * from {{ source('aw_person','businessentityaddress')}}

),

final as (
    select
      {{ dbt_utils.generate_surrogate_key(['businessentityid', 'addressid'])}} as business_entity_address_sk,
      businessentityid as business_entity_id,
      addressid as address_id,
      addresstypeid as address_type_id,
      rowguid as row_guid,
      modifieddate as last_update

    from businessentityaddress
)

select * from final