*There are a few steps required in getting your local homepage vagrant box running*

1) Download and Install Virtualbox:

	https://www.virtualbox.org/wiki/Downloads


2) Download and install vagrant.

	https://www.vagrantup.com/downloads.html

3) Install the vagrant-vbguest plugin:

	sudo vagrant plugin install vagrant-vbguest


The Vagrant directory inside this repository contains the following files:

**Vagrantfile** - File read by vagrant, used to build the vagrant boxes.

**ansible.cfg** - config file used by ansible.

**db** - directory to place your database dump file. (Shipped empty)

**hosts** - "hosts" file used by ansible.

**playbook.yml** - main YAML file used by ansible

**roles**    - directory containing ansible configuration data

** aliases.drushrc.php ** - goes into ~/.drush/ on your host machine.  (Optional)

Once you complete the vagrant provisioning step, you'll see an additional directory: .vagrant, which contains metadata and configuration files for Vagrant.

4) Next, copy, or symlink the contents of the directory into "homepage/".  Insure that your drupal code is placed in here.
   Example:

cp -rvp /path/to/your/ConnectCode homepage

**or**

ln -s /path/to/your/Connect/ homepage

**Symlinks are strongly recommended.**




5) **DB Dump**:  Insure your SQL dump file is in bz2 format, and called homepage_sql.bz2.  Place it in the db folder described above.

6) **DB User and password** The Ansible playbook used to build this vagrant box will create the database user and set its password. For security purposes, these variables have been redacted.  Please edit the file roles/mariadb/vars/main.yaml, and add the correct username and password.  This can be found in the code, specifically in sites/dev.homepage.com/settings.php, *on or about line 17*. The password should contain single quotes around it.  ex: 'MyP4SSW0rD!?}'





**Shared Directories:**

One of the benefits of using Vagrant to provision development VMs is the ability to expose host side subdirectories inside the VM.  You can use your favorite IDE on your host side to develop code, and browse to the VM to view it.

**Please Note:**

As shipped by default, the homepage/ directory maps to /var/www/homepage internally on the VM. /var/www/public_html is what apache is configured to use as its document root.

This can be changed by modifying the bolded section of the line inside Vagrantfile:

config.vm.synced_folder **"homepage/"**,"/var/www/homepage",create:true

to wherever on your filesystem the code lives, this is completely optional, but is worth mentioning.

7) Add the following entry to your local hosts file:  127.0.0.1 local.dev.homepage.com

**Provisioning the VM**

To prepare the VM for use, you'll need to bring it up.   The first time you bring up a Vagrant box it will perform a number of tasks, including downloading a VM image if its not alreay installed, and configuring apache, mariadb *(mysql), and php.

To prepare the VM, run the following:

vagrant up --provider=virtualbox

The first time you bring the VM up, it will also perform a "vagrant provision"  which will run through the ansible playbook.  It's worth noting that you can run 'vagrant provision' at any time, and it will revert any changes to your system's configuration files (not your drupal codE)  This also includes reloading homepage_sql.bz2 located in the  **db** folder.  This is a good way to safely refresh your database.

**Please Note:**


Vagrant configures a link between a TCP port on your local host and an internal port on the Virtual machine, for any internal homepageivity (such as browsing to the internal web server)  currently, port 8888 on your localhost will map to port 80 inside the VM.  If you're currently running a service on 8888, you'll need to change that.  

edit Vagrantfile, and search for the line:

    config.vm.network :forwarded_port, guest: 80, host: 8888    

Changing 8888 to the port of your choosing.


The provisioning steps will take about 15 to 20 minutes. Once it's completed, you can bring up a web browser on your host, and browse to

  http://local.dev.homepage.com:8888/

If everything was performed correctly, you should see your dev site.  Please note, as of the writing of this document, certain features, namely single sign on, and salesforce integration may not work.   I am in the process of researching a way to get these items to work.   


The files in the vagrant repository may change as neccesary to add features and fix bugs. (Or is that the other way around?) Please make sure you keep these files up to date.  
