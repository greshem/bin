#!/bin/sh

if [ "$TMPDIR" = "" ]; then
  TMPDIR=/tmp
fi
#######################################################################################3
if [ -x `which mcookie` ]; then
  COOKIE=`mcookie`
else
  COOKIE=$$
fi
if [ "$1" = "" ]; then
  echo "$0:  Converts RPM format to standard tar or zip format."
  echo
  echo "Usage:      $0 <file.rpm>"
  if [ "`basename $0`" = "rpm2tgz" ]; then
    echo "            (Outputs \"file.tgz\")"
  else
    echo "            (Outputs \"file.tar.gz\")"
  fi
  exit 1;
fi
for i in $* ; do
  if [ ! "$1" = "$*" ]; then
    echo -n "Processing file: $i"
  fi
  rm -rf $TMPDIR/rpm2targz$COOKIE # clear the way, just in case of mischief
  mkdir $TMPDIR/rpm2targz$COOKIE
############################################################
  if which getrpmtype 1> /dev/null 2> /dev/null; then
    if getrpmtype -n $i | grep source 1> /dev/null 2> /dev/null ; then
      isSource=1
    else
      isSource=0
    fi
  else 
    if file $i | grep RPM | grep " src " 1> /dev/null 2> /dev/null ; then
      isSource=1
    else
      isSource=0
    fi
  fi

  ofn=$TMPDIR/rpm2targz$COOKIE/`basename $i .rpm`.cpio
  if which rpm2cpio 1> /dev/null 2> /dev/null ; then
    rpm2cpio $i > $ofn 2> /dev/null
    if [ ! $? = 0 ]; then
      echo "... rpm2cpio failed.  (maybe $i is not an RPM?)"
      ( cd $TMPDIR ; rm -rf rpm2targz$COOKIE )
      continue
    fi
  else # less reliable than rpm2cpio...
    dd ibs=`rpmoffset < $i` skip=1 if=$i 2> /dev/null | gzip -dc > $ofn
  fi
  DEST=$TMPDIR/rpm2targz$COOKIE
  if [ "$isSource" = "1" ]; then
     DEST=$DEST/$(basename $(basename $i .rpm) .src)
  fi
  mkdir -p $DEST
  ( cd $DEST
    cpio --extract --preserve-modification-time --make-directories < $ofn 1> /dev/null 2> /dev/null
    rm -f $ofn
    find . -type d -perm 700 -exec chmod 755 {} \; )
  ( cd $TMPDIR/rpm2targz$COOKIE ; tar cf - . ) > `basename $i .rpm`.tar
  gzip -9 `basename $i .rpm`.tar
  if [ "`basename $0`" = "rpm2tgz" ]; then
    mv `basename $i .rpm`.tar.gz `basename $i .rpm`.tgz
  fi
  ( cd $TMPDIR ; rm -rf rpm2targz$COOKIE )
  echo
done
echo "del the rpm"
#rm -f $1;
