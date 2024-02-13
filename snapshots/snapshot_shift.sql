{% snapshot snapshot_shift %}

{{
    config(
      target_schema='snapshots',
      unique_key='shiftid',

      strategy='timestamp',
      updated_at='modifieddate'
    )
}}

select * from {{ source('aw_humanresources', 'shift') }}

{% endsnapshot %}