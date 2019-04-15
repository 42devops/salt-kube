salt:
  ssh_roster:
    {% for eachminion, each_mine in salt['mine.get']('*', 'host').iteritems() -%}
    {{eachminion}}:
      host: {{each_mine[0]}}
      user: root
    {% endfor -%}
