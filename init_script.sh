azcopy login --identity
azcopy copy "https://storage93594sa.blob.core.windows.net/asa-container/index.html" "/usr/share/nginx/html/index.html"
# curl "https://storage93594sa.blob.core.windows.net/asa-container/index.html" -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer ${TOKEN}" > /var/www/html/index.html
