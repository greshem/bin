
#!/usr/bin/python
DATA="""
curl "http://localhost:8086/db?u=root&p=root"-d "{\"name\": \"collectd\"}"
curl -G 'http://localhost:8086/db/collectd/series?

http://192.168.82.173:8086/query?q=SHOW+STATS&db=_internal
http://192.168.82.173:8086/query?q=SHOW+DIAGNOSTICS&db=_internal

"""
print DATA; 
