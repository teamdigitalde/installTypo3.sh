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
        'debug' => true,
        'loginSecurityLevel' => 'rsa',
        'pageNotFound_handling' => 'USER_FUNCTION:typo3conf/ext/sitepackage/Resources/Private/Php/pageNotFound.php:user_pageNotFound->pageNotFound',
        'passwordHashing' => [
            'className' => 'TYPO3\\CMS\\Core\\Crypto\\PasswordHashing\\BcryptPasswordHash',
            'options' => [],
        ],
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
        'dce' => [
            'packagePath' => 'typo3conf/ext/dce/',
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

#copy .htaccess
#cp typo3_src/_.htaccess typo3/.htaccess

#basic access-restriction (beta/seite;)
printf "
# basic access-restriction (beta/seite;)
AuthName 'Geschützter Bereich'
AuthType Basic
AuthUserFile ${workingdirectory}/.htpasswd
require valid-user" >> .htaccess

mv .htaccess ../../..
mv index.php ../../..
mv autoload ../..

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
