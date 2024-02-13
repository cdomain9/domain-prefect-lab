   with person as (

   select 
      business_entity_id,
      person_type,
      name_style,
      title,
      first_name,
      midde_name,
      last_name,
      suffix,
      email_promotion,
      additional_contact_info,
      demographics,
      row_guid,
      last_update

    from {{ ref('stg_person') }}
   )

   select * from person