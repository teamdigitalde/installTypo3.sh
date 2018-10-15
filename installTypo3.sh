#!/bin/bash

url="http://get.typo3.org/9"
target="t3latest.tar.gz"
workingdirectory=${PWD}

clear

echo "Getting the TYPO3 Sources from ${url}, writing to ${target}"
# get the sourcec
wget $url -O $target --no-check-certificate > /dev/null 2>&1
# untar the tar ball
tar -xzf $target > /dev/null
# remove tar ball
rm -f $target

# delete typo3
rm -rf typo3
# make typo3 directory
mkdir typo3
# rename sources directory
mv typo3_src-* typo3_src

#copy .htaccess
cp typo3_src/_.htaccess typo3/.htaccess

#add Apache-Tuning to htaccess
printf '
#####
#
# Example .htaccess file for TYPO3 CMS - for use with Apache Webserver
#
# This file includes settings for the following configuration options:
#
# - Compression
# - Caching
# - MIME types
# - Cross Origin requests
# - Rewriting and Access
# - Miscellaneous
# - PHP optimisation
#
# If you want to use it, you have to copy it to the root folder of your TYPO3 installation (if its
# not there already) and rename it to '.htaccess'. To make .htaccess files work, you might need to
# adjust the 'AllowOverride' directive in your Apache configuration file.
#
# IMPORTANT: You may need to change this file depending on your TYPO3 installation!
#            Consider adding this file's content to your webserver's configuration directly for speed improvement
#
# Lots of the options are taken from https://github.com/h5bp/html5-boilerplate/blob/master/dist/.htaccess
#
####


### Begin: Compression ###

# Compressing resource files will save bandwidth and so improve loading speed especially for users
# with slower internet connections. TYPO3 can compress the .js and .css files for you.
# *) Uncomment the following lines and
# *) Set $GLOBALS['TYPO3_CONF_VARS']['BE']['compressionLevel'] = 9 for the Backend
# *) Set $GLOBALS['TYPO3_CONF_VARS']['FE']['compressionLevel'] = 9 together with the TypoScript properties
#    config.compressJs and config.compressCss for GZIP compression of Frontend JS and CSS files.

#<FilesMatch "\.js\.gzip$">
#	AddType "text/javascript" .gzip
#</FilesMatch>
#<FilesMatch "\.css\.gzip$">
#	AddType "text/css" .gzip
#</FilesMatch>
#AddEncoding gzip .gzip

<IfModule mod_deflate.c>
	# Force compression for mangled `Accept-Encoding` request headers
	<IfModule mod_setenvif.c>
		<IfModule mod_headers.c>
			SetEnvIfNoCase ^(Accept-EncodXng|X-cept-Encoding|X{15}|~{15}|-{15})$ ^((gzip|deflate)\s*,?\s*)+|[X~-]{4,13}$ HAVE_Accept-Encoding
			RequestHeader append Accept-Encoding "gzip,deflate" env=HAVE_Accept-Encoding
		</IfModule>
	</IfModule>

	# Compress all output labeled with one of the following media types.
	#
	# (!) For Apache versions below version 2.3.7 you dont need to
	# enable `mod_filter` and can remove the `<IfModule mod_filter.c>`
	# and `</IfModule>` lines as `AddOutputFilterByType` is still in
	# the core directives.
	#
	# https://httpd.apache.org/docs/current/mod/mod_filter.html#addoutputfilterbytype

	<IfModule mod_filter.c>
		AddOutputFilterByType DEFLATE application/atom+xml \
			application/javascript \
			application/json \
			application/ld+json \
			application/manifest+json \
			application/rdf+xml \
			application/rss+xml \
			application/schema+json \
			application/vnd.geo+json \
			application/vnd.ms-fontobject \
			application/x-font-ttf \
			application/x-javascript \
			application/x-web-app-manifest+json \
			application/xhtml+xml \
			application/xml \
			font/eot \
			font/opentype \
			image/bmp \
			image/svg+xml \
			image/vnd.microsoft.icon \
			image/x-icon \
			text/cache-manifest \
			text/css \
			text/html \
			text/javascript \
			text/plain \
			text/vcard \
			text/vnd.rim.location.xloc \
			text/vtt \
			text/x-component \
			text/x-cross-domain-policy \
			text/xml
	</IfModule>

	<IfModule mod_mime.c>
		AddEncoding gzip svgz
	</IfModule>
</IfModule>

### End: Compression ###



### Begin: Browser caching of resource files ###

# This affects Frontend and Backend and increases performance.
<IfModule mod_expires.c>

	ExpiresActive on
	ExpiresDefault                                      "access plus 1 month"

	ExpiresByType text/css                              "access plus 1 year"

	ExpiresByType application/json                      "access plus 0 seconds"
	ExpiresByType application/ld+json                   "access plus 0 seconds"
	ExpiresByType application/schema+json               "access plus 0 seconds"
	ExpiresByType application/vnd.geo+json              "access plus 0 seconds"
	ExpiresByType application/xml                       "access plus 0 seconds"
	ExpiresByType text/xml                              "access plus 0 seconds"

	ExpiresByType image/vnd.microsoft.icon              "access plus 1 week"
	ExpiresByType image/x-icon                          "access plus 1 week"

	ExpiresByType text/x-component                      "access plus 1 month"

	ExpiresByType text/html                             "access plus 0 seconds"

	ExpiresByType application/javascript                "access plus 1 year"
	ExpiresByType application/x-javascript              "access plus 1 year"
	ExpiresByType text/javascript                       "access plus 1 year"

	ExpiresByType application/manifest+json             "access plus 1 week"
	ExpiresByType application/x-web-app-manifest+json   "access plus 0 seconds"
	ExpiresByType text/cache-manifest                   "access plus 0 seconds"

	ExpiresByType audio/ogg                             "access plus 1 month"
	ExpiresByType image/bmp                             "access plus 1 month"
	ExpiresByType image/gif                             "access plus 1 month"
	ExpiresByType image/jpeg                            "access plus 1 month"
	ExpiresByType image/png                             "access plus 1 month"
	ExpiresByType image/svg+xml                         "access plus 1 month"
	ExpiresByType image/webp                            "access plus 1 month"
	ExpiresByType video/mp4                             "access plus 1 month"
	ExpiresByType video/ogg                             "access plus 1 month"
	ExpiresByType video/webm                            "access plus 1 month"

	ExpiresByType application/atom+xml                  "access plus 1 hour"
	ExpiresByType application/rdf+xml                   "access plus 1 hour"
	ExpiresByType application/rss+xml                   "access plus 1 hour"

	ExpiresByType application/vnd.ms-fontobject         "access plus 1 month"
	ExpiresByType font/eot                              "access plus 1 month"
	ExpiresByType font/opentype                         "access plus 1 month"
	ExpiresByType application/x-font-ttf                "access plus 1 month"
	ExpiresByType application/font-woff                 "access plus 1 month"
	ExpiresByType application/x-font-woff               "access plus 1 month"
	ExpiresByType font/woff                             "access plus 1 month"
	ExpiresByType application/font-woff2                "access plus 1 month"

	ExpiresByType text/x-cross-domain-policy            "access plus 1 week"

</IfModule>

### End: Browser caching of resource files ###


### Begin: MIME types ###

# Proper MIME types for all files
<IfModule mod_mime.c>

	# Data interchange
	AddType application/atom+xml                        atom
	AddType application/json                            json map topojson
	AddType application/ld+json                         jsonld
	AddType application/rss+xml                         rss
	AddType application/vnd.geo+json                    geojson
	AddType application/xml                             rdf xml

	# JavaScript
	AddType application/javascript                      js

	# Manifest files
	AddType application/manifest+json                   webmanifest
	AddType application/x-web-app-manifest+json         webapp
	AddType text/cache-manifest                         appcache

	# Media files

	AddType audio/mp4                                   f4a f4b m4a
	AddType audio/ogg                                   oga ogg opus
	AddType image/bmp                                   bmp
	AddType image/svg+xml                               svg svgz
	AddType image/webp                                  webp
	AddType video/mp4                                   f4v f4p m4v mp4
	AddType video/ogg                                   ogv
	AddType video/webm                                  webm
	AddType video/x-flv                                 flv
	AddType image/x-icon                                cur ico

	# Web fonts
	AddType application/font-woff                       woff
	AddType application/font-woff2                      woff2
	AddType application/vnd.ms-fontobject               eot
	AddType application/x-font-ttf                      ttc ttf
	AddType font/opentype                               otf

	# Other
	AddType application/octet-stream                    safariextz
	AddType application/x-bb-appworld                   bbaw
	AddType application/x-chrome-extension              crx
	AddType application/x-opera-extension               oex
	AddType application/x-xpinstall                     xpi
	AddType text/vcard                                  vcard vcf
	AddType text/vnd.rim.location.xloc                  xloc
	AddType text/vtt                                    vtt
	AddType text/x-component                            htc

</IfModule>

# UTF-8 encoding
AddDefaultCharset utf-8
<IfModule mod_mime.c>
	AddCharset utf-8 .atom .css .js .json .manifest .rdf .rss .vtt .webapp .webmanifest .xml
</IfModule>

### End: MIME types ###



### Begin: Cross Origin ###

# Send the CORS header for images when browsers request it.
<IfModule mod_setenvif.c>
	<IfModule mod_headers.c>
		<FilesMatch "\.(bmp|cur|gif|ico|jpe?g|png|svgz?|webp)$">
			SetEnvIf Origin ":" IS_CORS
			Header set Access-Control-Allow-Origin "*" env=IS_CORS
		</FilesMatch>
	</IfModule>
</IfModule>

# Allow cross-origin access to web fonts.
<IfModule mod_headers.c>
	<FilesMatch "\.(eot|otf|tt[cf]|woff2?)$">
		Header set Access-Control-Allow-Origin "*"
	</FilesMatch>
</IfModule>

### End: Cross Origin ###



### Begin: Rewriting and Access ###

# You need rewriting, if you use a URL-Rewriting extension (RealURL, CoolUri).

<IfModule mod_rewrite.c>

	# Enable URL rewriting
	RewriteEngine On

	# Store the current location in an environment variable CWD to use
	# mod_rewrite in .htaccess files without knowing the RewriteBase
	RewriteCond $0#%{REQUEST_URI} ([^#]*)#(.*)\1$
	RewriteRule ^.*$ - [E=CWD:%2]

	# Rules to set ApplicationContext based on hostname
	#RewriteCond %{HTTP_HOST} ^dev\.example\.com$
	#RewriteRule .? - [E=TYPO3_CONTEXT:Development]
	#RewriteCond %{HTTP_HOST} ^staging\.example\.com$
	#RewriteRule .? - [E=TYPO3_CONTEXT:Production/Staging]
	#RewriteCond %{HTTP_HOST} ^www\.example\.com$
	#RewriteRule .? - [E=TYPO3_CONTEXT:Production]

	# Rule for versioned static files, configured through:
	# - $GLOBALS['TYPO3_CONF_VARS']['BE']['versionNumberInFilename']
	# - $GLOBALS['TYPO3_CONF_VARS']['FE']['versionNumberInFilename']
	# IMPORTANT: This rule has to be the very first RewriteCond in order to work!
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteCond %{REQUEST_FILENAME} !-d
	RewriteRule ^(.+)\.(\d+)\.(php|js|css|png|jpg|gif|gzip)$ %{ENV:CWD}$1.$3 [L]

	# Access block for folders
	RewriteRule _(?:recycler|temp)_/ - [F]
	RewriteRule fileadmin/templates/.*\.(?:txt|ts)$ - [F]
	RewriteRule ^(?:vendor|typo3_src|typo3temp/var) - [F]
	RewriteRule (?:typo3conf/ext|typo3/sysext|typo3/ext)/[^/]+/(?:Configuration|Resources/Private|Tests?|Documentation|docs?)/ - [F]

	# Block access to all hidden files and directories with the exception of
	# the visible content from within the `/.well-known/` hidden directory (RFC 5785).
	RewriteCond %{REQUEST_URI} "!(^|/)\.well-known/([^./]+./?)+$" [NC]
	RewriteCond %{SCRIPT_FILENAME} -d [OR]
	RewriteCond %{SCRIPT_FILENAME} -f
	RewriteRule (?:^|/)\. - [F]

	# Stop rewrite processing, if we are in the typo3/ directory or any other known directory
	# NOTE: Add your additional local storages here
	RewriteRule ^(?:typo3/|fileadmin/|typo3conf/|typo3temp/|uploads/|favicon\.ico) - [L]

	# If the file/symlink/directory does not exist => Redirect to index.php.
	# For httpd.conf, you need to prefix each '%{REQUEST_FILENAME}' with '%{DOCUMENT_ROOT}'.
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteCond %{REQUEST_FILENAME} !-d
	RewriteCond %{REQUEST_FILENAME} !-l
	RewriteRule ^.*$ %{ENV:CWD}index.php [QSA,L]

</IfModule>

# Access block for files
# Apache < 2.3
<IfModule !mod_authz_core.c>
    <FilesMatch "(?i:^\.|^#.*#|^(?:ChangeLog|ToDo|Readme|License)(?:\.md|\.txt)?|^composer\.(?:json|lock)|^ext_conf_template\.txt|^ext_typoscript_constants\.txt|^ext_typoscript_setup\.txt|flexform[^.]*\.xml|locallang[^.]*\.(?:xml|xlf)|\.(?:bak|co?nf|cfg|ya?ml|ts|typoscript|tsconfig|dist|fla|in[ci]|log|sh|sql(?:\..*)?|sw[op]|git.*)|.*(?:~|rc))$">
        Order allow,deny
        Deny from all
        Satisfy All
    </FilesMatch>
</IfModule>
# Apache ≥ 2.3
<IfModule mod_authz_core.c>
    <If "%{REQUEST_URI} =~ m#(?i:/\.|/\x23.*\x23|/(?:ChangeLog|ToDo|Readme|License)(?:\.md|\.txt)?|/composer\.(?:json|lock)|/ext_conf_template\.txt|/ext_typoscript_constants\.txt|/ext_typoscript_setup\.txt|flexform[^.]*\.xml|locallang[^.]*\.(?:xml|xlf)|\.(?:bak|co?nf|cfg|ya?ml|ts|typoscript|tsconfig|dist|fla|in[ci]|log|sh|sql(?:\..*)?|sw[op]|git.*)|.*(?:~|rc))$#">
        Require all denied
    </If>
</IfModule>

# Block access to vcs directories
<IfModule mod_alias.c>
	RedirectMatch 404 /\.(?:git|svn|hg)/
</IfModule>

### End: Rewriting and Access ###



### Begin: Miscellaneous ###

# 404 error prevention for non-existing redirected folders
Options -MultiViews

# Make sure that directory listings are disabled.
<IfModule mod_autoindex.c>
	Options -Indexes
</IfModule>

<IfModule mod_headers.c>
	# Force IE to render pages in the highest available mode
	Header set X-UA-Compatible "IE=edge"
	<FilesMatch "\.(appcache|crx|css|eot|gif|htc|ico|jpe?g|js|m4a|m4v|manifest|mp4|oex|oga|ogg|ogv|otf|pdf|png|safariextz|svgz?|ttf|vcf|webapp|webm|webp|woff2?|xml|xpi)$">
		Header unset X-UA-Compatible
	</FilesMatch>

	# Reducing MIME type security risks
	Header set X-Content-Type-Options "nosniff"
</IfModule>

# ETag removal
<IfModule mod_headers.c>
	Header unset ETag
</IfModule>
FileETag None

### End: Miscellaneous ###


# Add your own rules here.

# Basic security checks
# - no access for .git repository dir
RewriteRule ^(.*/)?\.git+ - [R=404,L]
# - Restrict access to sql dumps
RewriteRule ^.*(\.sql)$ - [F]
<IfModule mod_rewrite.c>
# rewrite non-www on HTTP connection
#RewriteCond %{HTTPS} off
#RewriteCond %{HTTP_HOST} !^www\.(.*)$ [NC]
#RewriteRule ^(.*)$ http://www.%{HTTP_HOST}/$1 [R=301,L]

# rewrite non-www on HTTPS connection
#RewriteCond %{HTTPS} on
#RewriteCond %{HTTP_HOST} !^www\.(.*)$ [NC]
#RewriteRule ^(.*)$ https://www.%{HTTP_HOST}/$1 [R=301,L]

# rewrite dd_googlesitemap
RewriteRule ^sitemap.xml$ /index.php?eID=dd_googlesitemap [L]
</IfModule>

#activate browser caching
<IfModule mod_expires.c>
 ExpiresActive On
 ExpiresByType text/css "access plus 1 week"
 ExpiresByType application/javascript "access plus 1 month"
 ExpiresByType application/x-javascript "access plus 1 month"
 ExpiresByType image/gif "access plus 1 month"
 ExpiresByType image/jpeg "access plus 1 month"
 ExpiresByType image/png "access plus 1 month"
 ExpiresByType image/x-icon "access plus 1 year"
 ExpiresByType application/x-shockwave-flash "access plus 1 months"
</IfModule>

#enable Gzip compression
<IfModule mod_deflate.c>
 <FilesMatch "\.(js|css|html|xml|txt|php)$">
 SetOutputFilter DEFLATE
 </FilesMatch>
</IfModule>

#set etag headers
<IfModule mod_headers.c>
 Header unset ETag
 FileETag None
</IfModule>' >> typo3/.htaccess

#basic access-restriction (beta/seite;)
printf "
# basic access-restriction (beta/seite;)
AuthName 'Geschützter Bereich'
AuthType Basic
AuthUserFile ${workingdirectory}/.htpasswd
require valid-user" >> typo3/.htaccess

#htpasswd
printf 'beta:$1$$.OPcLRctp0tpQ81Db9tKP/' >> .htpasswd

#change to typo3 directory
cd typo3/

#create fileadmin, user_upload and typo3conf
mkdir fileadmin
cd fileadmin
mkdir user_upload
cd user_upload
ln -s ../../typo3conf/ext/sitepackage/Resources/Public/Images/Grids/ Grids
cd ../
cd ../
mkdir typo3conf

#create symlinks
ln -s ../typo3_src/ typo3_src
ln -s typo3_src/typo3 typo3

#create a git repository
git init > /dev/null

#pull TYPO3 Skeleton from github
#git pull https://github.com/teamdigitalde/TYPO3_Skeleton.git > /dev/null 2>&1

#mkdir typo3conf
cd typo3conf
touch LocalConfiguration.php
db=datenbankname
du=datenbankuser
dh=Hostname
dp=datenbankpasswort
installPasswort='$P$CAMstFeZNWquvENdiz4fxuKMY21hVL0'
touch LocalConfiguration.php
read -p 'Datenbankname: ' db
read -p 'Datenbankuser: ' du
read -p 'Hostname: ' dh
read -p 'Datenbankpasswort: ' dp
printf "
<?php
return [
    'BE' => [
        'debug' => false,
        'explicitADmode' => 'explicitAllow',
        'installToolPassword' => '"$installPasswort"',
        'loginSecurityLevel' => 'rsa',
    ],
    'DB' => [
        'Connections' => [
            'Default' => [
                'charset' => 'utf8',
                'dbname' => '"$db"',
                'driver' => 'mysqli',
                'host' => '"$dh"',
                'password' => '"$dp"',
                'port' => 3306,
                'user' => '"$du"',
            ],
        ],
    ],
    'EXT' => [
        'extConf' => [
            'filemetadata' => 'a:0:{}',
            'gridelements' => 'a:2:{s:20:"additionalStylesheet";s:0:"";s:19:"nestingInListModule";s:1:"0";}',
            'realurl' => 'a:6:{s:10:"configFile";s:64:"typo3conf/ext/sitepackage/Resources/Private/Php/realurl_conf.php";s:14:"enableAutoConf";s:1:"1";s:14:"autoConfFormat";s:1:"0";s:17:"segTitleFieldList";s:0:"";s:12:"enableDevLog";s:1:"0";s:10:"moduleIcon";s:1:"0";}',
            'rsaauth' => 'a:1:{s:18:"temporaryDirectory";s:0:"";}',
            'saltedpasswords' => 'a:2:{s:3:"BE.";a:4:{s:21:"saltedPWHashingMethod";s:41:"TYPO3\\CMS\\Saltedpasswords\\Salt\\Pbkdf2Salt";s:11:"forceSalted";i:0;s:15:"onlyAuthService";i:0;s:12:"updatePasswd";i:1;}s:3:"FE.";a:5:{s:7:"enabled";i:1;s:21:"saltedPWHashingMethod";s:41:"TYPO3\\CMS\\Saltedpasswords\\Salt\\Pbkdf2Salt";s:11:"forceSalted";i:0;s:15:"onlyAuthService";i:0;s:12:"updatePasswd";i:1;}}',
            'sitepackage' => 'a:0:{}',
            'bootstrapslider' => 'a:0:{}',
        ],
    ],
    'EXTCONF' => [
        'lang' => [
            'availableLanguages' => [
                'de',
            ],
        ],
    ],
    'FE' => [
        'debug' => false,
        'loginSecurityLevel' => 'rsa',
        'pageNotFound_handling' => 'USER_FUNCTION:typo3conf/ext/sitepackage/Resources/Private/Php/pageNotFound.php:user_pageNotFound->pageNotFound',
    ],
    'GFX' => [
        'jpg_quality' => '80',
        'processor' => 'GraphicsMagick',
        'processor_allowTemporaryMasksAsPng' => false,
        'processor_colorspace' => 'RGB',
        'processor_effects' => -1,
        'processor_enabled' => true,
        'processor_path' => '/usr/bin/',
        'processor_path_lzw' => '/usr/bin/',
    ],
    'MAIL' => [
        'transport' => 'sendmail',
        'transport_sendmail_command' => '/usr/sbin/sendmail -t -i ',
        'transport_smtp_encrypt' => '',
        'transport_smtp_password' => '',
        'transport_smtp_server' => '',
        'transport_smtp_username' => '',
    ],
    'SYS' => [
        'caching' => [
            'cacheConfigurations' => [
                'extbase_object' => [
                    'backend' => 'TYPO3\\CMS\\Core\\Cache\\Backend\\Typo3DatabaseBackend',
                    'frontend' => 'TYPO3\\CMS\\Core\\Cache\\Frontend\\VariableFrontend',
                    'groups' => [
                        'system',
                    ],
                    'options' => [
                        'defaultLifetime' => 0,
                    ],
                ],
            ],
        ],
        'devIPmask' => '',
        'displayErrors' => 0,
        'enableDeprecationLog' => false,
        'encryptionKey' => '5ad2b220f239fd6aeb5615444010fd3ce1d110f6de9c5df917cdbf1c8ca8349034fa2c06272ab77b755f006c88a23187',
        'exceptionalErrors' => 20480,
        'isInitialDatabaseImportDone' => true,
        'isInitialInstallationInProgress' => false,
        'sitename' => 'New TYPO3 site',
        'sqlDebug' => 0,
        'systemLogLevel' => 2,
    ],
];

" >> LocalConfiguration.php

touch PackageStates.php
printf "
<?php
# PackageStates.php

# This file is maintained by TYPO3's package management. Although you can edit it
# manually, you should rather use the extension manager for maintaining packages.
# This file will be regenerated automatically if it doesn't exist. Deleting this file
# should, however, never become necessary if you use the package commands.

return [
    'packages' => [
        'core' => [
            'packagePath' => 'typo3/sysext/core/',
        ],
        'extbase' => [
            'packagePath' => 'typo3/sysext/extbase/',
        ],
        'fluid' => [
            'packagePath' => 'typo3/sysext/fluid/',
        ],
        'install' => [
            'packagePath' => 'typo3/sysext/install/',
        ],
        'frontend' => [
            'packagePath' => 'typo3/sysext/frontend/',
        ],
        'fluid_styled_content' => [
            'packagePath' => 'typo3/sysext/fluid_styled_content/',
        ],
        'info' => [
            'packagePath' => 'typo3/sysext/info/',
        ],
        'info_pagetsconfig' => [
            'packagePath' => 'typo3/sysext/info_pagetsconfig/',
        ],
        'extensionmanager' => [
            'packagePath' => 'typo3/sysext/extensionmanager/',
        ],
        'lang' => [
            'packagePath' => 'typo3/sysext/lang/',
        ],
        'setup' => [
            'packagePath' => 'typo3/sysext/setup/',
        ],
        'rte_ckeditor' => [
            'packagePath' => 'typo3/sysext/rte_ckeditor/',
        ],
        'rte_ckeditor_image' => [
            'packagePath' => 'typo3conf/ext/rte_ckeditor_image/',
        ],
        'rsaauth' => [
            'packagePath' => 'typo3/sysext/rsaauth/',
        ],
        'saltedpasswords' => [
            'packagePath' => 'typo3/sysext/saltedpasswords/',
        ],
        'func' => [
            'packagePath' => 'typo3/sysext/func/',
        ],
        'wizard_crpages' => [
            'packagePath' => 'typo3/sysext/wizard_crpages/',
        ],
        'wizard_sortpages' => [
            'packagePath' => 'typo3/sysext/wizard_sortpages/',
        ],
        'about' => [
            'packagePath' => 'typo3/sysext/about/',
        ],
        'backend' => [
            'packagePath' => 'typo3/sysext/backend/',
        ],
        'belog' => [
            'packagePath' => 'typo3/sysext/belog/',
        ],
        'beuser' => [
            'packagePath' => 'typo3/sysext/beuser/',
        ],
        'context_help' => [
            'packagePath' => 'typo3/sysext/context_help/',
        ],
        'cshmanual' => [
            'packagePath' => 'typo3/sysext/cshmanual/',
        ],
        'documentation' => [
            'packagePath' => 'typo3/sysext/documentation/',
        ],
        'bootstrapslider' => [
            'packagePath' => 'typo3conf/ext/bootstrapslider/',
        ],
        'felogin' => [
            'packagePath' => 'typo3/sysext/felogin/',
        ],
        'filelist' => [
            'packagePath' => 'typo3/sysext/filelist/',
        ],
        'filemetadata' => [
            'packagePath' => 'typo3/sysext/filemetadata/',
        ],
        'form' => [
            'packagePath' => 'typo3/sysext/form/',
        ],
        'impexp' => [
            'packagePath' => 'typo3/sysext/impexp/',
        ],
        'lowlevel' => [
            'packagePath' => 'typo3/sysext/lowlevel/',
        ],
        'recordlist' => [
            'packagePath' => 'typo3/sysext/recordlist/',
        ],
        'recycler' => [
            'packagePath' => 'typo3/sysext/recycler/',
        ],
        'reports' => [
            'packagePath' => 'typo3/sysext/reports/',
        ],
        'rte_ckeditor_image' => [
            'packagePath' => 'typo3conf/ext/rte_ckeditor_image/',
        ],
        'scheduler' => [
            'packagePath' => 'typo3/sysext/scheduler/',
        ],
        'sv' => [
            'packagePath' => 'typo3/sysext/sv/',
        ],
        'sys_note' => [
            'packagePath' => 'typo3/sysext/sys_note/',
        ],
        't3editor' => [
            'packagePath' => 'typo3/sysext/t3editor/',
        ],
        'tstemplate' => [
            'packagePath' => 'typo3/sysext/tstemplate/',
        ],
        'viewpage' => [
            'packagePath' => 'typo3/sysext/viewpage/',
        ],
        'gridelements' => [
            'packagePath' => 'typo3conf/ext/gridelements/',
        ],
        'sitepackage' => [
            'packagePath' => 'typo3conf/ext/sitepackage/',
        ],
    ],
    'version' => 5,
];

" >> PackageStates.php

touch ENABLE_INSTALL_TOOL
mkdir ext
cd ext

mkdir sitepackage
cd sitepackage
git init > /dev/null
git pull https://github.com/teamdigitalde/sitepackage > /dev/null 2>&1

mysql -u $du -p$dp --default_character_set utf8 -h $dh $db < kickstart.sql
rm -rf kickstart.sql

cd ../
mkdir bootstrapslider
cd bootstrapslider
git init > /dev/null
git pull https://github.com/teamdigitalde/bootstrapslider > /dev/null 2>&1

cd ../
mkdir gridelements
cd gridelements
git init > /dev/null
git pull https://github.com/TYPO3-extensions/gridelements > /dev/null 2>&1

cd ../
mkdir dce
cd dce
git init > /dev/null
git pull https://bitbucket.org/ArminVieweg/dce/src > /dev/null 2>&1

cd ../
mkdir rte_ckeditor_image
cd rte_ckeditor_image
git init > /dev/null
git pull https://github.com/netresearch/t3x-rte_ckeditor_image > /dev/null 2>&1

echo " "
echo "Done. Feel free to buy me a Beer :-)"
echo " "
echo "Now you can call the InstallTool and continue Installing TYPO3"
