<?php
$home = drush_server_home();
$aliases['vagrant.homepage'] = array(
   'root' => '/var/www/public_html',
   'remote-host' => '127.0.0.1',
   'remote-user' => 'vagrant',
   'ssh-options' => "-p 2222 -i $home/.vagrant.d/insecure_private_key",
   'uri' => 'local.dev.homepage.com:8888',
 );
