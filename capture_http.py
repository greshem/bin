import pcap  
import dpkt  
  
pc = pcap.pcap('br100')  
pc.setfilter('tcp port 80')  
  
for ptime,pdata in pc:  
    p = dpkt.ethernet.Ethernet(pdata)  
    if p.data.__class__.__name__ == 'IP':  
        ip='%d.%d.%d.%d' % tuple(map(ord,list(p.data.dst)))  
        if p.data.data.__class__.__name__ == 'TCP':  
            if p.data.data.dport == 80 and len(p.data.data.data)>0:  
                http = dpkt.http.Request(p.data.data.data)  
                #print "type=%s"%type(http);
                #print http;
                print "%s|%s|%s|%s" %(http.method,http.headers['host'], http.uri,http.body);
                #print http.body;
