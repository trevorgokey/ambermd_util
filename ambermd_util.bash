#!/bin/bash
function fail
{
   local msg=$1
   [ "$msg" ] || msg="No message given."
   echo "$msg Exiting"
   exit 1
}

function amu_protocol_rm_comment
{
	sed -e "/^\s*#/d" -e "/^$/d" -e 's/^\(.*\)#.*$/\1/' $1
}

function amu_protocol_clean
{
amu_protocol_rm_comment <( sed -e "/^\s*|/d" -e "s/\t/ /g" $1 ) 
#amu_protocol_rm_comment <( sed -e "s/\t/ /g" $1 ) 
}

function amu_get_project_name
{
    delim=${1:--}
    local proj=""
    local cwd=""
    local p=`realpath .`
    local ifs=$IFS
    local in=""
#   for i in $p ; do
#        cwd="${cwd}/$i"
#        [ -f "${cwd}/IS_BASE" ] && in="1"
#        [ $in ] && proj="${proj}-$i"
#        [ -f "${cwd}/IS_PROJ" ] && break
#    done
    # look for IS_PROJ, get count
    # if more than one, take ./IS_PROJ since deeper is undefined
    IFS="/"
    for i in $p ; do
        cwd="${cwd}/$i"
        if [ -f "${cwd}/IS_BASE" ] ; then 
           in="1"
        fi
        [ $in ] && proj="${proj}${delim}$i"
        [ -f "${cwd}/IS_PROJ" ] && last=$proj
#if [ $have_proj -eq 0 ] ; then 
#[ -f "${cwd}/IS_PROJ" ] && [ "${cwd}" == "/$(realpath .)" ] && break
#else
#fi
    done
    proj=$last
    IFS=$ifs
    echo $proj | sed s:^\\${delim}::
}

function amu_get_step
{
    p=`pwd`
    b=`basename $p`
    printf "%d" ${b}
}

PROJ=""
[ -f IS_PROJ ] && PROJ=1
