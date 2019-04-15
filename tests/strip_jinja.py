#!/usr/bin/env python

import sys

def strip_jinja(text,delims):
  # delims should be a tuple, one of ("{%","%}") or ("{{","}}")
  while delims[0] in text:
    lpos=text.find(delims[0])
    rpos=text.find(delims[1],lpos)
    left=text[0:lpos]
    right=text[rpos+len(delims[1]):]
    text=left+right
  return text

for sls in sys.argv[1:]:

  with open(sls,'r') as fh:
    lines=fh.readlines()
    text="".join(lines)
    text=strip_jinja(text,("{%","%}"))
    text=strip_jinja(text,("{{","}}"))
    text=strip_jinja(text,("{#","#}"))
    print text

