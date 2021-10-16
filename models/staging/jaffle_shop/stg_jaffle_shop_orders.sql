with

source as (

    select * from {{ source('dbt_bthompson', 'orders') }}

)

select * from source