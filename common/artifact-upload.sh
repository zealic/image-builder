UPLOAD_HOST=${UPLOAD_HOST:-RZ-DSM:5005}
UPLOAD_URL=http://$UPLOAD_HOST/build/distro/$(basename $TARGET_FILE)

echo Uploading $(basename $TARGET_FILE) ...
curl -u anonymous: -T "$TARGET_FILE" $UPLOAD_URL
