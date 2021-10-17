#!/bin/bash

if [ ! -f config ]; then
    echo -n "Generating config... "
    echo "# Generated on $(date)" > config
    cat airgapi-config >> config
    echo "Done"
fi

echo -n "Copying config... "
cat config > pi-gen/config
echo "Done"

if [ ! -f pi-gen/patched ]; then

    echo "Verifying patch..."
    gpg --verify airgapi.patch.asc
    if [ $? -eq 0 ]; then
        echo "Done"
    else
        echo "Invalid patch"
        exit 1
    fi

    echo "Applying patch..."
    gpg --decrypt airgapi.patch.asc > pi-gen/airgapi.patch

    cd pi-gen
    git am --reject --whitespace=fix airgapi.patch
    rm -f airgapi.patch
    cd ..

    echo "# Patched on $(date)" > pi-gen/patched

    echo "Done"

fi

echo -n "Skipping stage4... "
touch pi-gen/stage4/SKIP pi-gen/stage4/SKIP_IMAGES
echo "Done"

echo -n "Skipping stage5... "
touch pi-gen/stage5/SKIP pi-gen/stage5/SKIP_IMAGES
echo "Done"

echo "Ready to build!"
echo "Run ./build-airgapi.sh to build"
