with person as (
    select * from {{ source('aw_person','person')}}

),

final as (
    select 
      businessentityid as business_entity_id,
      persontype as person_type,
      namestyle as name_style,
      title,
      firstname as first_name,
      middlename as midde_name,
      lastname as last_name,
      suffix,
      emailpromotion as email_promotion,
      additionalcontactinfo as additional_contact_info,
      demographics,
      rowguid as row_guid,
      modifieddate as last_update

    from person  
)

select * from final