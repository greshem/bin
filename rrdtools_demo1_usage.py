#!/usr/bin/python
DATA="""
rrdtool create example1.rrd --start 920804400 --step 300 DS:speed:COUNTER:600:U:U RRA:AVERAGE:0.5:1:24 RRA:AVERAGE:0.5:6:10  


rrdtool update example1.rrd 920805600:12363 920805900:12363 920806200:12373 920806500:12383 920806800:12393 920807100:12399 920807400:12405 920807700:12411 920808000:12415 920808300:12420 920808600:12422 920808900:12423  

rrdtool graph example1.png --start 920805000 --end 920810000 --vertical-label km/h --imgformat PNG DEF:myspeed=example1.rrd:speed:AVERAGE CDEF:kmh=myspeed,3600,* CDEF:fast=kmh,100,GT,kmh,0,IF CDEF:good=kmh,100,GT,0,kmh,IF VDEF:mymax=myspeed,MAXIMUM VDEF:myavg=myspeed,AVERAGE LINE:100#990000:"Maximum Allowed" AREA:good#006600:"Good Speed" AREA:fast#CC6633:"Too Fast" LINE:myavg#000099:"My Average":STACK GPRINT:myavg:"%6.2lf kph"  

"""
print DATA;
