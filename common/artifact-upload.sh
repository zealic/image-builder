UPLOAD_HOST=${UPLOAD_HOST:-RZ-DSM:5005}
UPLOAD_URL=http://$UPLOAD_HOST/build/distro/$(date +%Y-%m)
UPLOAD_FILE=$UPLOAD_URL/$(basename $TARGET_FILE)

# WebDAV upload
echo Uploading $(basename $TARGET_FILE) ...
curl -sS -u anonymous: -X MKCOL UPLOAD_URL
curl --fail -sS -u anonymous: -T "$TARGET_FILE" $UPLOAD_URL
