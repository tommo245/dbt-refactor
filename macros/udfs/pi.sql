{% macro make_func_math_pi () %}

CREATE OR REPLACE FUNCTION `{{ target.project }}`.`{{ target.dataset }}`.pi() RETURNS FLOAT64 AS (3.141592653589793);

{% endmacro %}
