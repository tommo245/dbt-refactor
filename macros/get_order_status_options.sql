{% macro get_order_status_options() %}

{% set order_status_query %}
select distinct order_status from `dbt-refactor`.`dbt_bthompson`.`fct_customer_orders`
{% endset %}

{% set results = run_query(order_status_query) %}

{{ log(results, info=True) }}

{% set results_list = [] %}

{% if execute %}
{% set results_list = results.columns[0].values() %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}