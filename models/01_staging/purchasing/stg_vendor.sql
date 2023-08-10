with vendor as (
    select * from {{ source('aw_purchasing','vendor')}}

),

final as (
    select 
      businessentityid as vendor_record_id,
      accountnumber as account_number,
      name as vendor_name,
      creditrating as vendor_credit_rating,
      preferredvendorstatus as preferred_vendor_status,
      activeflag as active_flag,
      purchasingwebserviceurl as purchasing_web_svc_url,
      modifieddate as last_update

    from vendor  
)

select * from final