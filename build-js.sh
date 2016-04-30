#!/usr/bin/env bash
set -e
root=$(readlink -e $(dirname $0))

cd $root
if [ -z "$GOPATH" ]; then
	export GOPATH=$PWD/go
	mkdir -p $GOPATH
fi

if [ ! -f $GOPATH/bin/minify ]; then
  echo "set up minifiy"  
	go get -v github.com/tdewolff/minify/cmd/minify
fi
outfile=$(readlink -e ./contrib/static/nntpchan.js)

mini() {
    echo "minify $1"
    echo "" >> $2
    echo "/* $1 */" >> $2
    $GOPATH/bin/minify --mime=text/javascript >> $2 < $1
}

echo -e "//For source code and license information please check https://github.com/majestrate/nntpchan \n" > $outfile

mini ./contrib/js/main.js_ $outfile

if [ ! -e ./contrib/js/contrib/MathJax/MathJax.js ] ; then
    git submodule --init update .
fi
mini ./contrib/js/contrib/MathJax/MathJax.js $outfile

# local js
for f in ./contrib/js/*.js ; do
  mini $f $outfile
done
echo "ok"
