{% snapshot snapshot_jobcandidate %}

{{
    config(
      target_schema='snapshots',
      unique_key='jobcandidateid',

      strategy='timestamp',
      updated_at='modifieddate'
    )
}}

select * from {{ source('aw_humanresources', 'jobcandidate') }}

{% endsnapshot %}