# Developer SDK Documentation

This documentation aims to help new developers set their Apple Macintosh environment to work correctly with the UH Servers and efficiently develop web technologies, mobile applications and other development software on their local machine.

- Last Tested For: macOS Sierra 10.14.2
- Last Updated By: Ryan Thompson
- Last Updated On: December 18, 2018

## Required Prerequisite Dependencies

The following dependecies should be downloaded from their corresponding vendors **before any other steps.**

1. [Mozilla Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/)
3. [Iterm 2](http://www.iterm2.com/downloads.html)
5. [Xcode](https://developer.apple.com/xcode/)
6. Xcode Command Line Tools ```xcode-select --install```
7. [Macports](https://www.macports.org/install.php)

**NOTE**: Now that you have installed all the necessary dependencies, you can begin preparing your local development machine. **All terminal commands are issued using the new Iterm 2**. However, it is preferable that you install the recommnded dependencies as well.


## Recommended Prerequisite Dependencies
1. [Google Chrome](https://www.google.com/chrome/browser/desktop/index.html)
2. [Mozilla Firefox Regular](https://www.mozilla.org/en-US/firefox/)
4. [TextEditor (i.e. atom)](https://atom.io/)

## Preparing Your System
Before you can start the installation of the webserver, you need to update some permission, directory, credentials, helper files, and system configurations.

### Update Macports
Make sure macports is using the latest port trees.

```
sudo port -d selfupdate
```

### Users & Groups
In order to keep permissions consistent and easy to manage between local development and the cloud, we need to create a webdev group and add your user to the group. Additionally, we need to add the _www user to the webdev group for running the webserver.

Create a group called webdev for root, your user and apache user to use and avoid permission issues.

```
sudo dseditgroup -o create -r "Web Developers" webdev
```
Add your user to the new webdev group

```
sudo dseditgroup -o edit -a $USER -t user webdev
```

Add the _www user to the webdev group

```
sudo dseditgroup -o edit -a _www -t user webdev
```
Add root to the webdev group for avoidance of permission issues later.

```
sudo dseditgroup -o edit -a root -t user webdev
```
Check the users in the group. You should only see root, _www and your $USER.

```
sudo dscl . -read /Groups/webdev GroupMembership
```

### Directory Setup

The current helper files are designed to use the same directory setup for all machines in order to avoid differences between environments. The following commands below will make the directories and then change the permissions to be ready for your system to use.

This will make a global development directory where all your webfiles, applications,  apache confs, libs, and git repositories, etc. will live.

This will make the publish directory and all its sub directories for your webserver.

```
sudo mkdir -p /development/publish/lib/ /development/publish/http/
```

This will make the git directory and its sub directories for your git repositories, including your developer tools. Any namespace for CodeCommit can become a directory in the git directory on your local machine.

```
sudo mkdir -p /development/git/lib/ /development/git/developer/
```
Now you need to create a symbolic link from /development/publish/ to /publish/ to allow applications to see files from the root perspective and avoid permission clashes.

```
sudo ln -s /development/publish/ /publish
```

Lets do the same thing for git so you can access it from the root of the file system.

```
sudo ln -s /development/git/ /git
```

Now when you need to navigate to git or publish, you can do so with:

``` cd /publish ``` or ``` cd /git ```

It is highly recommended that you use the symbolic links, instead of the development directory to work with as the development directory is really just a container for future sdk updates to live without being all over the system.

### Permission Changes

All the directories above were created using the sudo command and so are given root level access and placed in the wheel or staff group. We need clean up our permissions to user your $USER as the owner and webdev as the group. Follow the steps below to do this.

Change the development directory to use your username and the webdev group recursively.

```
sudo chown -R $USER:webdev /development/
```
Change the permissions on the development directory to be 775 recursively.

```
sudo chmod -R 775 /development/
```

Once you have finished setting up the developer tools, you will be able to run ```fix permissions``` instead of running these all the time. This is for pure convenience but you should know what is happening under the hood (hint: check the code out)

### SSH Creation
To generate an ssh key for secure connect follow these steps.

In the terminal, issue the following command to generate the ssh, which will try to create it in ~/.ssh/ directory. Pay attention to the configuration and fill it in appropriately.

```
ssh-keygen -t rsa
```

Display your new sshkey to put into CodeCommit with the following command:

```
cat ~/.ssh/id_rsa.pub
```

**NOTE**: In CodeCommit, go to your account and add your publish sshkey. Also, add your ssh key to any other remote places you want to ssh to.

##### SSH in AWS
In order to get AWS CodeCommit to accept your credentials, you need to create a config file with .ssh by creating a new file in ~/.ssh/config

``` vi ~/.ssh/config ```

Now add the following to the file where User is the SSH key ID listed with your public SSH in AWS.

```
Host git-codecommit.*.amazonaws.com
  User {YOUR_SSH_KEY_ID_IN_AWS}
  IdentityFile ~/.ssh/id_rsa
```

Now save the file!

### Hostname Config
**(Dont forget this)**
Set your hostname to your $USER.local for host related situations.

```
sudo scutil --set HostName $USER.local
```

### Install Git
After Xcode, the Xcode command line tools, and macports are installed, you can use macports to install git and download libraries to your machine.

```
sudo port install git
```

Once installation is complete, you will need to configure git with these options.

```
git config --global user.name $USER
git config --global credential.helper osxkeychain
git config --global color.branch auto
git config --global color.diff auto
git config --global color.interactive auto
git config --global color.status auto
```

### Obtain Developer Tools

Now you need to clone the developer sdk to your machine by cloning:

```
clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/sdk /git/developer/sdk/
```

### Include Loader

You will need to add the following line to your ``~/.bash_profile`` to include in your terminal. Once you have made the change, start a new terminal shell.

```
if [ -f /development/git/developer/sdk-cli/loader ]; then
  source /development/git/developer/sdk-cli/loader
fi
```

After you reload the terminal, you should not see any errors and notice some color styling. You also have new commands you can use to make developing faster.

### Set DNS Hosts

In order to efficiently use your machine, we are going to set some DNS Host records to match our vhosts files for our subdomains and different servernames. Follow the steps below to set your host records correctly.

Using the terminal, open the host file with the command: ```sudo vi /etc/hosts```

Edit your file to include the follow host names pointing to 127.0.0.1.

```
127.0.0.1 {$USER}.local localhost local.starcomm.io
```

**NOTE:** It is highly important that you include the ``{$USER}.local`` portion, but make sure to **change the {$USER} portion to your actual hostname**. This piece should match what you set the hostname in the previous step.

Once you have added these you will be able to access your different docroots by the hostname in the browser. If you have other subdomains you would like to configure, you can do that now.

### Restart
Now you should restart the machine and verify that all the changes you made are in effect and without errors. Before moving on to the next section on server setup, please **Restart your machine**.


## Local App Development
In addition to other technologies, we need to use nodejs, yarn, and other app server development occurs. The next section of the documentation will go over installing nodejs, yarn, and getting them configured on your machine.

### Install NodeJS v8

``` sudo port install nodejs8```

### Install Yarn
``` sudo port install yarn```

At this time, there appears to be no issues with the default configurations and you should be able to use ```yarn``` and ```node```.

## Closing Remarks

If you keep experiencing issues, the best option is to try again from the beginning and use the internet as a resource. You can also ask the most recent contributor for assistance if you still are having issues, as well as senior members of the team.
