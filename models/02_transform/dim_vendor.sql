with vendor as (
    select
      vendor_record_id,
      account_number,
      vendor_name,
      vendor_credit_rating,
      preferred_vendor_status,
      active_flag,
      purchasing_web_svc_url,
      last_update
    from {{ref('stg_vendor')}}
)

select * from vendor