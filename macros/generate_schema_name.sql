{% macro generate_schema_name(custom_schema_name, node) -%}
    
    {%- set default_schema = target.schema -%}

    -- In case the model is in a nested intermediates folder
    {%- if 'intermediates' in node.fqn -%}
      {% do return('prep') %}
    {% endif %}

    {% if not custom_schema_name %}
      {% do return(default_schema) %}
    {% endif %}

    {% do return(custom_schema_name) %}

{%- endmacro %}
