#!/bin/bash
# ------------------------------------------------------------
# Download external JS content to public cache folder
# ------------------------------------------------------------
rm -Rf public/cdnjs.cloudflare.com

mkdir -p public/cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2
mkdir -p public/cdnjs.cloudflare.com/ajax/libs/jsviews/0.9.75
mkdir -p public/cdnjs.cloudflare.com/ajax/libs/easyXDM/2.4.17.1
mkdir -p public/cdnjs.cloudflare.com/ajax/libs/es6-promise/3.2.1
mkdir -p public/cdnjs.cloudflare.com/ajax/libs/yepnope/1.5.4
mkdir -p public/cdnjs.cloudflare.com/ajax/libs/lodash-compat/3.10.2
mkdir -p public/cdnjs.cloudflare.com/ajax/libs/Base64/0.3.0
mkdir -p public/cdnjs.cloudflare.com/ajax/libs/require.js/2.2.0

wget -O public/cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js https://cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js
wget -O public/cdnjs.cloudflare.com/ajax/libs/jsviews/0.9.75/jsviews.min.js https://cdnjs.cloudflare.com/ajax/libs/jsviews/0.9.75/jsviews.min.js
wget -O public/cdnjs.cloudflare.com/ajax/libs/easyXDM/2.4.17.1/easyXDM.min.js https://cdnjs.cloudflare.com/ajax/libs/easyXDM/2.4.17.1/easyXDM.min.js
wget -O public/cdnjs.cloudflare.com/ajax/libs/easyXDM/2.4.17.1/json2.min.js https://cdnjs.cloudflare.com/ajax/libs/easyXDM/2.4.17.1/json2.min.js
wget -O public/cdnjs.cloudflare.com/ajax/libs/es6-promise/3.2.1/es6-promise.min.js https://cdnjs.cloudflare.com/ajax/libs/es6-promise/3.2.1/es6-promise.min.js
wget -O public/cdnjs.cloudflare.com/ajax/libs/yepnope/1.5.4/yepnope.min.js https://cdnjs.cloudflare.com/ajax/libs/yepnope/1.5.4/yepnope.min.js
wget -O public/cdnjs.cloudflare.com/ajax/libs/lodash-compat/3.10.2/lodash.min.js https://cdnjs.cloudflare.com/ajax/libs/lodash-compat/3.10.2/lodash.min.js
wget -O public/cdnjs.cloudflare.com/ajax/libs/Base64/0.3.0/base64.min.js https://cdnjs.cloudflare.com/ajax/libs/Base64/0.3.0/base64.min.js
wget -O public/cdnjs.cloudflare.com/ajax/libs/require.js/2.2.0/require.min.js https://cdnjs.cloudflare.com/ajax/libs/require.js/2.2.0/require.min.js
