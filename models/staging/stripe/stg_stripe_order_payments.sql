with

source as (

    select * from {{ ref('stg_stripe_payments') }}
    where status <> 'fail'

),

transformed as (

    select
        orderid as order_id,
        max(created) as payment_finalized_date,
        sum(amount) / 100.0 as total_amount_paid
    
    from source
    group by 1

)

select * from transformed