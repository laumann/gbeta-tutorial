#! /bin/bash -norc

if [ "$ipath" = "" ]; then
    ipath=$HOME/eernst/gbeta/tools/trunk/gbeta
fi

VALHALLAOPTS_PREFIX="-EXEC $ipath/main/gbeta -BOPT DragOutlineOnOpen FALSE -CL $ipath/src/"
export VALHALLAOPTS;
#export IBETA_TRACE=IOl

function grunargs ()
{
    opts=()
    while [[ "$1" == -* ]]; do
        opts[${#opts}+1]=$1
        shift
    done
    for n in "$@"; do
	echo '------------------------------' $n
	if gbeta "${(@)opts}" $n; then
        else
	    echo '******************************' $n
	    read
	fi
    done
}

function brunargs ()
{
    opts=()
    while [[ "$1" == -* ]]; do
        opts[${#opts}+1]=$1
        shift
    done
    for n in "$@"; do
	echo '---------------' $n
	# use "implicit cast OK" type checking, for BETA compatibility
	if gbeta --relaxed-type-check "${(@)opts}" $n; then
	else
	    echo '***************' $n
	    read
	fi
    done
}

function grunall () { grunargs "$@" *.gb; }
function brunall () { brunargs "$@" *.bet; }

function trun ()
{
    pushd $ipath/nodist/oldsrc >/dev/null
    ./run-test
    popd >/dev/null
}

function tfrun ()
{
    pushd $ipath/nodist/fragsrc >/dev/null
    ./run-test
    popd >/dev/null
}

function tdrun ()
{
    pushd $ipath/nodist/dynsrc >/dev/null
    ./run-test
    popd >/dev/null
}

function drun ()
{
    for n; do
        VALHALLAOPTS=${VALHALLAOPTS_PREFIX}$n
        valhalla $ipath/src/main/gbeta
    done
}

function cdmp ()
{
    less -S gbeta-*.dump
}

function interplines ()
{
    pushd $ipath/src >/dev/null
    wc -l `lrb | grep -ve /CVS/ | grep -ve /scan/`
    popd >/dev/null
}

function interpbackup ()
{
    pushd $ipath/.. >/dev/null
    gtar czvf interp.tgz `find $gbetaver/. ! -name \*.a2s ! -name \*.o ! -name \*.go ! -name \*.db\* ! -name \*.ast ! -name \*.astL ! -name \*.dump ! -name \*.ps.gz ! -name \*.ps ! -name \*.html ! -type d`
    popd >/dev/null
}

function checkinterpbackup ()
{
    find $ipath -name \*$1 -print | wc -l
    gtar tvf $ipath/../interp.tar | grep $1 | wc -l
}

# zsh version of interptags:

function interptags ()
{
    # Selection regex: identifiers with 3 or more chars, starting at
    # beginning of line; or starting midline, preceded by non-identifier char
    rgx='/\(\|.*[^a-zA-Z_0-9]\)\([a-zA-Z_][a-zA-Z_0-9][a-zA-Z_0-9]+\):/\2/'
    local -a files
    files=($(find $ipath/src -name \*.bet -type f | grep -ve /Base/))
    etags -l none --regex=$rgx $files 2>/dev/null
}

# With bash, use the following version (difference is word splitting and
# rules for setting/scoping local variables):
#
#  function interptags ()
#  {
#      rgx='/\(\|.*[^a-zA-Z_0-9]\)\([a-zA-Z_][a-zA-Z_0-9][a-zA-Z_0-9]+\):/\2/'
#      local files=$(find $ipath/src -name \*.bet -type f | grep -ve /Base/)
#      etags -l none --regex=$rgx $files 2>/dev/null
#  }

function gtags ()
{
    # gbeta version of interptags
    rgx='/\(\|.*[^a-zA-Z_0-9]\)\([a-zA-Z_][a-zA-Z_0-9][a-zA-Z_0-9]+\):/\2/'
    local -a files
    files=($(find $(pwd) -name \*.gb -type f | grep -ve /Base/))
    etags -l none --regex=$rgx $files 2>/dev/null
}

function gbkill ()
{
    kill "$@" $(/sbin/pidof $gbetaver-i386-linux-elf-bin)
}

function gbarg ()
{
    psallg '[g]beta-' | awk '{ print $NF; }'
}

function cmpgbc ()
{
    regex='^ *[a-zA-Z]*('
    echo '------------------------------' $1
    diff <(cat $1 | fgrep "$regex" | sort) \
         <(parsegbc < $1 | fgrep "$regex" | sort)
}

function allcmpgbc ()
{
    for n in *.gbc; do cmpgbc $n; done
}

function gbcgen () {
    for n in *.gb *.bet; do
	if [ -f $n -a -r $n ]; then gbeta -g $n; fi
    done
}

function gbcgenr () {
    startdir=$(pwd)
    for d in $(find -type d); do
	cd $d
	gbcgen
	cd $startdir
    done
}

# ----- Temporary items -----


# Local variables:
# mode: shell-script
# end:
