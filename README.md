# SPECjbb2005

### 介绍
SPECjbb2005(Java Business Benchmark)基准测试模拟一个三层架构环境来进行JAVA 应用服务器测试， 目的是衡量应用服务器端JAVA 应用之性能。正规SPECjbb2005 测试结果发布必须提供bops 值, 即每秒钟完成多少笔JAVA 业务操作(Business Operation Per Second), 同时要求提供完整的测试环境资料。

### 配置
每个"warehouse"会产生一个独立的线程，从而决定测试线程的并发数。

具体在使用过程中需要修改配置文件SPECjbb.props，根据所测试服务器核数多少来设置warehouse，一般warehouse为核数的两倍。

下面为配置文件主要参数：



    input.starting_number_warehouses=0

    input.increment_number_warehouses=1

    input.ending_number_warehouses=8

    input.sequence_of_number_of_warehouses=1 2 3 4 5 6 7 8

    //warehouse设置为8，每次增量为1，初始化时为0，打印的序列号为1-8。即测试服务器核数为4。

    input.ramp_up_seconds=30

    //warehouse未到达核数时，每个warehouse测试时间为30秒。

    input.measurement_seconds=240

    //warehouse超过核数时，每个warehouse测试时间为240秒。
### 运行
主要配置文件参数设置结束后，然后可以直接开始测试，因为测试的命令比较繁琐，因此写成一个脚本操作。

- `chmod +x ./run.sh`

- `./run.sh`

run.sh内容

```shell
echo $CLASSPATH
CLASSPATH=./jbb.jar:./check.jar:$CLASSPATH
echo $CLASSPATH
export CLASSPATH
export LD_LIBRARY_PATH=$THORDIR/lib

JAVA=/usr/bin/java
$JAVA -fullversion

$JAVA -Xms2048m -Xmx2048m spec.jbb.JBBmain -propfile SPECjbb.props
```

这里关于-Xms2048m -Xmx2048m需要注意，-Xmx2048m:设置JVM最大可用内存为2048M.-Xms2048m:设置JVM促使内存为2048m.此值可以设置与-Xmx相同,以避免每次垃圾回收完成后JVM重新分配内存.且这里设置内存大小标准为，不要超过服务器内存的80%。超过后性能会降低，如果分配内存过少，性能也会较低。

### 结果
 SPECjbb2005比较好用的一点是，输出结果时会同时生成走势图。走势图和warehouse结果都在results/SPECjbbSingleJVM里。


参考资料:

---
1. [csdn guofu8241260](http://blog.csdn.net/guofu8241260/article/details/9232747)
2. [fujitsu](https://sp.ts.fujitsu.com/dmsp/Publications/public/Benchmark_Overview_SPECjbb2005.pdf)
