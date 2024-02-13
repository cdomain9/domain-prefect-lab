{% snapshot snapshot_employeedepartmenthistory %}

{{
    config(
      target_schema='snapshots',
      unique_key='employee_department_history_sk',

      strategy='timestamp',
      updated_at='modifieddate'
    )
}}

select businessentityid || '~' || departmentid as employee_department_history_sk, * from {{ source('aw_humanresources', 'employeedepartmenthistory') }}

{% endsnapshot %}