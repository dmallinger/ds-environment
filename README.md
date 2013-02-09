# The Data Science Environment Manager

## Overview
This is a [Chef](http://docs.opscode.com/chef_quick_overview.html) repository for easily setting up
a data science environment.  Right now, it's focused on my primary tools: Hadoop and R.  Hopefully
this repo will keep expanding over time and become a Swiss Army Knife of data science environment
management.  Currently, the 'local' role will:

1. Set up a pseudo-distributed Hadoop cluster
2. Ensure Hive and Pig are running properly
3. Install R
4. Install any R packages you've requested
5. Install and configure RHadoop (rhdfs and rmr2)

The goal is to make it easier for all of us to quickly setup machines, update environments, and get
into the good stuff that defines our work.

Note that the repo was built for single machine data science, namely my local laptop.  While I hope
to expand it to support clusters, it's not set up for that yet.  It does, however, allow enough
customization that shared analysis servers could be set up using this, or even separate environments
on said server.


## Roadmap
Future development is to include the following:

* Hue integration
* Mahout
* Dataset cookbooks (what's a DS environment without fun data?!)
* Snappy
* More than OS X support (Bueller?... Bueller?... Bueller?)
* An MPP cookbook


## Required Skills
The goal was to make an environment management repos that requires minimal "Unix-y" skills.  You
should only need to know how to:

* Utilize the command line for basic commands
* Edit JSON
* Address Unix errors that might come up (hopefully none on Mac OS X)


## Before You Run This
To run the script, you'll need to do a few things first

### Mac OS X
1. Install Chef with the simple command: `sudo gem install chef`
2. Setup the Chef data directory (unless you're an advanced user who changes these):
    sudo mkdir -p /var/chef
    sudo chmod -R 777 /var/chef
3. Make sure you can 'ssh localhost' from the terminal.  If you can't, open 
"System Preferences" > "Sharing" > and then check "Remote Login" from the list on the left.
4. Make your life easier by enabling passwordless SSH for your Hadoop install:
    ssh-keygen
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
5. Install XCode for Mac:
    1. Open the "App Store" and search for XCode
    2. Download and install
    3. Open XCode and go to "Preferences" > "Downloads" > "Components".  Click to install "Command Line Tools"
    4. Verify that you can run `g++` on the terminal and see the error "no input files"


## How to Run
The run process is very simple and is the same for first install as it is for subsequent updates:

`sudo chef-solo -c <solo.rb-location> -j <solo.json-location>`


## After You Run This
There are a few final steps that the cookbooks doesn't currently handle.

* You'll need to format the Hadoop namenode: `hadoop namenode -format`
* You'll want to run `start-all.sh` to start Hadoop; this repo doesn't install services
* You should also confirm that RHadoop installed properly using [their tutorial](https://github.com/RevolutionAnalytics/rmr2/blob/master/docs/tutorial.md)


## Key Variables
The example `solo.json` file in this repo should cover you, though you can look through 
the cookbooks for more details.  The key variables to considering updating are:

    java::remote_file_path, hadoop::remote_file_path, rstats::remote_file_path
This are the locations where local files are stored after download (e.g. Hadoop source).  By
storing these files, we limit the number of things downloaded when re-running the script.

    java::owner, java::group, hadoop::owner, hadoop::group
The user and group owners of the files and directories created in their cookbooks.  This is
important if you're installing to a user's home directory but `chef-solo` is run as root.

    java::profile_path, hadoop::profile_path
The profile.  Typically either a local .bashrc .bash_profile or the global /etc/bashrc /etc/profile

    Hadoop storage directories, e.g. hadoop::env::hadoop_conf_dir
The locations for the Hadoop directories for logs, configuration, data, etc.  If you're doing
a global (all users) install then probably under /etc/hadoop, otherwise in a user's home directory.

    rstats::r_profile_path, rstats::r_environ_path
The profile and environment for R.  Used to update options and set environment variables, 
e.g. HADOOP_CMD for RHadoop.

    rstats::packages
A list of packages to be installed for R.  Purely those you like and want in there by default.
