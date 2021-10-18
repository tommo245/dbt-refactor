{# in dbt Develop #}

{% set old_etl_relation_query %}
    select * from dbt_bthompson.customer_orders
{% endset %}

{% set new_etl_relation_query %}
    select * from {{ ref('fct_customer_orders') }}
{% endset %}

{% set audit_query = audit_helper.compare_column_values(
    a_query=old_etl_relation_query,
    b_query=new_etl_relation_query,
    primary_key="order_id",
    column_to_compare="order_status"
) %}

{% set audit_results = run_query(audit_query) %}

{% if execute %}
{% do audit_results.print_table() %}
{% endif %}
