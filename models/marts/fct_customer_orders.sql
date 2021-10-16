with

customers as (

    select * from {{ ref('stg_jaffle_shop_customers') }}

),

orders as (

    select * from {{ ref('stg_jaffle_shop_orders') }}

),

order_payments as (

    select * from {{ ref('stg_stripe_order_payments') }}

),

-- staging

-- intermediate



customer_orders as (

    select
        customers.id as customer_id,
        min(orders.order_date) as first_order_date,
        max(orders.order_date) as most_recent_order_date,
        count(orders.id) as number_of_orders

    from customers
    left join orders
        on orders.user_id = customers.id 
    group by 1

),

paid_orders as (
    
    select
        orders.id as order_id,
        orders.user_id as customer_id,
        orders.order_date as order_placed_at,
        orders.status as order_status,
        order_payments.total_amount_paid,
        order_payments.payment_finalized_date,
        customers.first_name as customer_first_name,
        customers.last_name as customer_last_name,

        row_number() over (order by orders.id) as transaction_seq,
        
        row_number() over (partition by orders.user_id
            order by orders.id) as customer_sales_seq,

        sum(order_payments.total_amount_paid)
            over (
                partition by orders.user_id
                rows between unbounded preceding and current row
            ) as customer_lifetime_value,
        
    from orders
    left join order_payments
        on orders.id = order_payments.order_id
    left join customers
        on orders.user_id = customers.id

),

-- final

final as (

    select
        paid_orders.*,
        customer_orders.first_order_date as fdos,

        case
            when customer_orders.first_order_date = paid_orders.order_placed_at
                then 'new'
            else 'return'
        end as nvsr,

    from paid_orders
    left join customer_orders
        on customer_orders.customer_id = paid_orders.customer_id
    order by paid_orders.order_id

)

select * from final