with

source as (

    select * from {{ source('dbt_bthompson', 'customers') }}

)

select * from source