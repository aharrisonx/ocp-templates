# Tools

## A collection of tools to make using OpenShift 4.x easier

## htpassfile
Add or update users and passwords to this file prior to setting up HTPasswd oauth on the cluster.  The command to add a new user to the existing file or update the password of an existing user in the file is `htpasswd -b htpassfile username password`. You can validate the passwords in the file with the command `htpasswd -v htpassfile username`. You will be prompted for the password and returned with either 
`Password verification failed`
or
`Password for user admin correct.`

To delete a user from the htpassfile, use the command `htpasswd -b -D htpassfile username password`

## Watch
There's no clear equivalent of the unix `watch` command in Windows. Copy this BASH script into your $PATH/bin directory and it will provide the ability to do things like `watch oc get nodes` to get a continuously updated feed of the `oc get nodes` command.

## oc-client
URL for downloading the appropriate version of the oc client.  The version of the oc client should match the version of OpenShift you are installing.

## oc-installer
URL for downloading the appropriate version of the OpenShift Installer.

## oc-mirror
URL for downloading the appropriate version of the oc-mirror tool for creating a private repo in disconnected/air-gapped environments.

## opm
URL for downloading the appropriate version of the opm CLI tool. This tool allows you to create and maintain catalogs of Operators from a list of bundles, called an index, that are similar to software repositories.
