{% snapshot snapshot_department %}

{{
    config(
      target_schema='snapshots',
      unique_key='departmentid',

      strategy='timestamp',
      updated_at='modifieddate'
    )
}}

select * from {{ source('aw_humanresources', 'department') }}

{% endsnapshot %}