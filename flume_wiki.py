#!/usr/bin/python
DATA="""
flume的一些核心概念：
Agent        使用JVM 运行Flume。每台机器运行一个agent，但是可以在一个agent中包含多个sources和sinks。
Client        生产数据，运行在一个独立的线程。
Source        从Client收集数据，传递给Channel。
Sink        从Channel收集数据，运行在一个独立线程。
Channel        连接 sources 和 sinks ，这个有点像一个队列。
Events        可以是日志记录、 avro 对象等。

"""
print DATA;
