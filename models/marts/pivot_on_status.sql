{%- set order_status_options =  get_order_status_options() -%}

select
    order_id,
    {%- for order_status_option in order_status_options %}
        sum(case when order_status = '{{ order_status_option }}' then total_amount_paid else 0 end) as {{ order_status_option }}_amount_paid
        {%- if not loop.last %},{% endif %}
    {%- endfor %}
from {{ ref('fct_customer_orders') }}
group by 1