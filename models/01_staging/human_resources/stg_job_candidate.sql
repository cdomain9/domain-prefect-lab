with jobcandidate as (
    select * from {{ source('aw_humanresources', 'jobcandidate')}}

),

final as (
    select
      jobcandidateid as job_candidate_id,
      businessentityid as employee_id,
      resume as candidate_resume,
      modifieddate as last_update
from jobcandidate
where jobcandidateid is not null

)

select * from final