##
## This is an example of what a run sh script might look like
##

date
echo $CLASSPATH
CLASSPATH=./jbb.jar:./check.jar:$CLASSPATH
echo $CLASSPATH
export CLASSPATH
export LD_LIBRARY_PATH=$THORDIR/lib

JAVA=/usr/bin/java
$JAVA -fullversion

$JAVA -Xms2048m -Xmx2048m spec.jbb.JBBmain -propfile SPECjbb.props
 
date

