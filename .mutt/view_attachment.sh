#!/bin/bash
#
# Purpose:  To be called by mutt as indicated by .mailcap to handle mail attachments.
#
# Function: Copy the given file to a temporary directory so mutt
#           Won't delete it before it is read by the application.
# the tmp directory to use.
tmpdir="$HOME/.tmp/mutt_attach"

# make sure the tmpdir exists.
mkdir -p $tmpdir

# clean it out.  Remove this if you want the directory
# to accumulate attachment files.
rm -f $tmpdir/*

# Mutt puts everything in /tmp by default.
# This gets the basic filename from the full pathname.
filename=`basename $1`

newfile=$tmpdir/$filename

# Copy the file to our new spot so mutt can't delete it
# before the app has a chance to view it.
cp $1 $newfile

xdg-open $newfile
