# Setup Local Web Server

This is a new document that was extended from the original README.md that attempts to help you setup a local web server.

## Web Server Development
Up until this point, you have not added any webserver components to your machine. However, we have successfully set the machine up to make installing a webserver much easier.

### Install Apache (v2)

Now that git is installed, we need to install apache, which will run the local server on your machine. To install apache, issue the following commands:

1. Issue the following command in Iterm to install apache2 using Macports.
```
sudo port install apache2
```
2. Install the mod_perl.so using macports by issuing the following command.
```
sudo port install mod_perl2
```


If you want Apache to run when your machine boots run the following command.

```
sudo launchctl load -w /Library/LaunchDaemons/org.macports.apache2.plist
```

### Install Nginx (v2)

```sudo port install nginx```

Thats it!, the rest is taken care of in the developer sdk using the sdk-update command.


### Setup SDK
Once you have finished installing Apache and PHP, you can now finish the configuration. To setup these configuration, you will need to run ``` sdk-update lib```. For future updates, the terminal will notify you when you need to run this again, although it shouldn't hurt to run it anytime to make sure to have the latest update.

### Perl Modules
The apache handlers use perl to attempt to fetch missing content from the production servers. In order for these to work, you will need to have a few perl modules installed.

To start, use CPAN to install the modules with: ```sudo perl -MCPAN -e shell;```
This will open the cpan shell. Now, you can install the needed libraries.

- ```install CGI```
- ```install LWP::UserAgent```
- ```install LWP::Protocol::https```
- ```install DBD::mysql```
- ```install XML::Bare```

You can run these all at once with the following command:
``` install CGI  LWP::UserAgent LWP::Protocol::https DBD::mysql XML::Bare```

### Sites Enabled/Available
To allow for a scalable solution, apache virtualhosts are available for use but may not be enabled by default. As such, in the ``/git/developer/sdk/lib/apache/sites/available/`` you can enable the hosts you would like to use.

In order to enable a website, you create a symbolic link from ```sites/available``` to ```sites/enabled/```. Please note that the best way to do this will be to navigate to the sites directory and create the symlink relatively.

This can be accomplished with ```cd /git/developer/sdk/lib/apache/sites/enabled/```, then a relative symlink for each site you want to enable.

**NOTE**: The reason for the numbers prior to the directory is to make vhosts load in that order should you use a domain name that is not already defined.

### Controlling the webserver

You have installed and configured everything needed to run a local webserver. You can control the webserver with the apache command.

```
apache [start|stop|restart]
```

You should be asked for your password and then apache should start. For those still wanting to use the apache2 command, you may continue to do this, but this command is scheduled for deprecation. Your WebServer should now be working at the desired domains you enabled.
