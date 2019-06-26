import base64
s=''
with open('hosts', 'r') as fd:
    s = fd.read()
print base64.b64encode(s)
