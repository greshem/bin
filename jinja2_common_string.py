#coding=utf-8
import json
import os;
import jinja2

templateLoader = jinja2.FileSystemLoader( searchpath="./" )

templateEnv = jinja2.Environment( loader=templateLoader )

api_name="Template";
api_url="http://192.168.82.173:8889/api/wzcloud/template_api";
data={
"Template_arg1": "Template_val1",
"Template_arg2": "Template_val2",
"Template_arg3": "Template_val3",
"Template_arg4": "Template_val4",
"Template_arg5": "Template_val5",
"Template_arg6": "Template_val6",
"Template_arg7": "Template_val7",
"Template_arg8": "Template_val8",
"Template_arg9": "Template_val9",
};

print templateEnv.from_string("""
{{api_url}}
{{api_name}}
<ul>
{% for each,each2 in  data.items()%}
    {{each}} {{each2}}
{% endfor %}
</ul>
""").render(data=data,  api_name=api_name, api_url=api_url)

