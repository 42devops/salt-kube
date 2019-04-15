{% if data['fun'] == 'state.apply' %}
alert_onfailure_highstate:
  runner.alert_on_failure.notify:
     - channel: 'eva'
     - data_str: {{ data | yaml_dquote }}
{% endif %}
