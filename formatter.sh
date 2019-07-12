#!/bin/sh

########################################################################
# Command line parameters
# Input raw-file
RAWFILE=$1

# Output file with consistent output
CONSISTENT=$2

########################################################################
# Changable parameters  
# Postfix of input file
POSTFIX=.sub

# Sript that splits one multi-jvm raw-file to the separate raw-files
SPLITTER=splitter.pl

# Directory where all the result files will be put
HOMEDIR=SPECjbb2005

# Java home and classpath
JAVA=java
CLASSPATH=~/SPEC/SPECjbb2005_73/build/dist/jbb.jar:$CLASSPATH
export CLASSPATH

########################################################################
# Determine if the results are multi- or single-jvm, and run appropriate 
# type of the reporter, then create a consistent output

TEMPDIR=tmp.$$

# Determine the number of JVMs
JVM=`grep 'input.jvm_instances' $RAWFILE | sed 's/^.*=\([0-9][0-9]*\).*/\1/'`

# Prefix for all file names
BASENAME=`basename $RAWFILE $POSTFIX`

mkdir $HOMEDIR 2> devnull

if [ "$JVM" -gt 1 ]; then
    # Multi-JVM case
    mkdir $TEMPDIR
    # Create the separate .raw files from one multi-jvm raw-file
    $SPLITTER $RAWFILE $TEMPDIR

    # For each jvm instance run single-jvm reporter as the benchmark does during its normal run
    x=1
    while [ "$x" -le "$JVM" ]; do
	INDEX=`printf "%03d\n" $x`
	java spec.reporter.Reporter -r $TEMPDIR/$BASENAME\_$INDEX.raw -o $TEMPDIR/$BASENAME\_$INDEX.html -s -l $BASENAME\_$INDEX
	x=`expr "$x" + 1`
    done

    # Run multi-jvm reporter (html and txt)
    java spec.reporter.MultiVMReporter -r $TEMPDIR -o $TEMPDIR/$BASENAME\.html -s -l $BASENAME -p $BASENAME\_
    java spec.reporter.MultiVMReporter -a -r $TEMPDIR -o $TEMPDIR/$BASENAME\.txt -p $BASENAME\_

    rm $TEMPDIR/*raw
    mv $TEMPDIR/* $HOMEDIR
    rm -r $TEMPDIR
else
    # Single-jvm case: run reporter (html and txt)
    java spec.reporter.Reporter -r $RAWFILE -o $HOMEDIR/$BASENAME.html -s -l $BASENAME
    java spec.reporter.Reporter -a -r $RAWFILE -o $HOMEDIR/$BASENAME.txt
fi

# Create a single, consistent output
cat $RAWFILE | sed 's/^/SPECjbb2005./' > $CONSISTENT 