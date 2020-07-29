#!/bin/bash

TMP_SH=copy_elf.sh

cat > "$TMP_SH" << EOF
#!/bin/sh
cp -f /bin/hugo /host/hugo
echo "ELF hugo copied!"
EOF

chmod a+x "$TMP_SH"

docker run --rm -it -v "`pwd`":/host --entrypoint "/host/$TMP_SH" klakegg/hugo:0.57.2

rm -f "$TMP_SH"
