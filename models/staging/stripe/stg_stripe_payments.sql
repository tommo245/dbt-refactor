with

source as (

    select * from {{ source('dbt_bthompson', 'payments') }}

)

select * from source