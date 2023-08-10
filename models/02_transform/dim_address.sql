with address as (

    select
      address_id,
      address_line_1,
      address_line_2,
      city,
      state_province_id,
      postal_code,
      spatial_location,
      row_guid,
      last_update
    From {{ref ('stg_address')}}

),

businessentityaddress as (

    select
      business_entity_id,
      address_id,
      address_type_id
    From {{ref ('stg_business_entity_address')}}

),

addresstype as (
    
    select 
      address_type,
      address_type_id
    from {{ ref('stg_address_type')}}
),

stateprovince as (
    select
      state_province_id,
      state_province_code,
      country_region_abbv,
      state_province_name,
      territory_id,
      row_guid,
      last_update
    from {{ref ('stg_state_province')}}
),

together as (

    select 
      
      b.business_entity_id,
      b.address_type_id,
      a_t.address_type,
      a.address_id,
      a.address_line_1,
      coalesce(a.address_line_2,'NA') as address_line_2, 
      a.city,
      sp.state_province_name,
      sp.state_province_code,
      a.postal_code,
      sp.country_region_abbv,
      a.spatial_location,
      a.row_guid,
      a.last_update
      FROM address a
      left join businessentityaddress b ON b.address_id = a.address_id
      left join addresstype a_t ON a_t.address_type_id = b.address_type_id
      left join stateprovince sp ON sp.state_province_id = a.state_province_id
)

select * from together