with customer as (
    select
      customer_id,
      person_id,
      store_id,
      territory_id,
      account_number,
      row_guid,
      last_update
    from {{ ref('stg_customer')}}
),

person as (
    select
      business_entity_id,
      title,
      first_name,
      last_name

    from {{ ref('stg_person')}}
),

business_entity_address as (
    select
      business_entity_id,
      address_id,
      address_type_id
    from {{ ref('stg_business_entity_address')}}
),

address_type as (
    select
      address_type_id,
      address_type
    from {{ ref('stg_address_type')}}
),

address as (
    select
      address_id,
      address_line_1,
      city,
      state_province_id,
      postal_code
    from {{ ref('stg_address') }}
),

sales_territory as (
    select
      sales_territory_id,
      sales_territory_name
    from {{ref('stg_sales_territory')}}
),

state_province as (
    select
      state_province_id,
      state_province_code,
      country_region_abbv
    from {{ref('stg_state_province')}}
),

final as (
    select
      /*c.customer_id || '~' || coalesce(a_t.address_type_id,-1) as customerid_addresstype_sk,*/
      c.customer_id,
      c.person_id,
      coalesce(p.title,p2.title) as title,
      coalesce(p.first_name, p2.first_name) as first_name,
      coalesce(p.last_name, p2.last_name) as last_name,
      coalesce(a_home.address_line_1, a_per_home.address_line_1) as home_address_line_1,
      coalesce (a_home.city,a_per_home.city) as home_city,
      coalesce(at_home.address_type_id,at_per_home.address_type_id) as home_address_type_id,
      coalesce(sp_home.state_province_code,sp_per_home.state_province_code) as home_state_province,
      coalesce(sp_home.country_region_abbv,sp_per_home.country_region_abbv) as home_country_region_abbv,
      coalesce(a_home.postal_code,a_per_home.postal_code) as home_postal_code,
      coalesce(a_ship.address_line_1,a_per_ship.address_line_1) as ship_address_line_1,
      coalesce (a_ship.city,a_per_ship.city) as ship_city,
      coalesce(at_ship.address_type_id,at_per_ship.address_type_id) as ship_address_type_id,
      coalesce(sp_ship.state_province_code,sp_per_ship.state_province_code) as ship_state_province,
      coalesce(sp_ship.country_region_abbv,sp_per_ship.country_region_abbv) as ship_country_region_abbv,
      coalesce(a_ship.postal_code,a_per_ship.postal_code) as ship_postal_code,
      st.sales_territory_name
    from customer c
    /*get home addresses where customer.CUSTOMER_ID = business_entity_address.business_entity_id are equal */
    left join business_entity_address bea_home on bea_home.business_entity_id = c.customer_id and bea_home.address_type_id = 2
    left join address a_home on a_home.address_id = bea_home.address_id
    left join address_type at_home on at_home.address_type_id = bea_home.address_type_id
    left join state_province sp_home on sp_home.state_province_id = a_home.state_province_id
    /* get shipping addresses where customer.customer_id = business_entity_address.business_entity_id are equal */
    left join business_entity_address bea_ship on bea_ship.business_entity_id = c.customer_id and bea_ship.address_type_id = 5
    left join address a_ship on a_ship.address_id = bea_ship.address_id
    left join address_type at_ship on at_ship.address_type_id = bea_ship.address_type_id
    left join state_province sp_ship on sp_ship.state_province_id = a_ship.state_province_id
    /* get home addresses where customer.person_id = business_entity_address.business_entity_id are equal */
    left join business_entity_address bea_per_home on bea_per_home.business_entity_id = c.person_id and bea_per_home.address_type_id = 2
    left join address a_per_home on a_per_home.address_id = bea_per_home.address_id
    left join address_type at_per_home on at_per_home.address_type_id = bea_per_home.address_type_id
    left join state_province sp_per_home on sp_per_home.state_province_id = a_per_home.state_province_id
    /* get shipping addresses where customer.person_id = business_entity_address.business_entity_id are equal */
    left join business_entity_address bea_per_ship on bea_per_ship.business_entity_id = c.person_id and bea_per_ship.address_type_id = 5
    left join address a_per_ship on a_per_ship.address_id = bea_per_ship.address_id
    left join address_type at_per_ship on at_per_ship.address_type_id = bea_per_ship.address_type_id
    left join state_province sp_per_ship on sp_per_ship.state_province_id = a_per_ship.state_province_id
    /* get data from person file where customer.customer_id = person.business_entity_id */
    left join person p on p.business_entity_id = c.customer_id
    /* get data from person file where customer.person_id = person.business_entity_id */
    left join person p2 on p2.business_entity_id = c.person_id
    /* get sales territory data */
    left join sales_territory st on st.sales_territory_id = c.territory_id
)

select * from final