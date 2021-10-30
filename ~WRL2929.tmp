Linnaeus University
Faculty of Technology – Department of Computer Science


2DV517 - Deployment Infrastructures
Examination 2




Students:
Tomas Marx-Raacz von Hidvég (tendn09)
Susanna Persson (sp222xw)
Dennis Demir (dd222gc)
Julia Perlkvist (jp223es)

Group: 6






Table of Contents

Table of Contents    2
Exploratory work and preparation    3
Workflow - trial, error and progress    3
Patterns    4
Immutable server    4
Push server configuration    4


Exploratory work and preparation

We started off the project by familiarizing ourselves with the tools and the contents of the website as it existed in its current state. For this, half of the group attempted to set up the old version of the website to gain an understanding of its different components and the steps involved in the setup, while the other half of the group began studying Ansible.

Since none of us had prior experience with Ansible or Terraform aside from reading about them in the prior assignment, we felt it was useful to have some group members to start learning the tools while others studied the infrastructure so that we then could share our new knowledge with each other and combine our understanding of the website with knowledge about how to automate the setup.

Of course, manual setup is a good first step to take before automating in order to figure out the steps involved and ensure that they work as intended. A bash script (link) was created for the initial setup of the old version of the website which gave some idea of what to do as a basis for then expanding and creating the new infrastructure and automating it.

Workflow - trial, error and progress
Our initial plan had been to rely on Ansible for automation as it seemed to be capable of achieving everything we needed, so that’s the route we went at first. Although we made decent progress with Ansible, especially with guidance from the previously created bash script, we encountered some issues and eventually we let go of the idea of relying on Ansible (old files from initial attempt) and agreed to instead use Terraform for the OpenStack side of things with networks and instances (Terraform folder) while using Ansible for the rest (Ansible folder).

For a while we wanted to have a bastion host as a point of entry to the network, as we had previously used jump machines in system administration courses and thought this could be useful. However we struggled a lot with making this work properly, and eventually decided to drop the idea before pouring too much time and effort into it that might be better used elsewhere.

After making progress with Ansible and Terraform we started to consider the monitoring aspect. For this we decided that we were going to use Prometheus (folder), and we also decided to use Grafana (folder) alongside it to present the data from Prometheus. Although we didn’t particularly have experience with monitoring, we had been introduced to Prometheus in a previous course and therefore felt that it was a good tool to choose since we had some sort of starting point for it.
Patterns
Immutable server
Immutable server, as described by Kief Morris [1], is where a server’s configuration is never changed, but rather new versions are created to replace old versions. This avoids potential risks of changing running servers, while also allowing you to make sure that the new server works as intended before removing the previous version. This pattern requires strong automation, but since we are overall focusing a lot on automation in this task this should not be a problem.
Push server configuration
Push server configuration, as described by Morris [1], 


Bibliography

[1]    K. Morris, Infrastructure as Code, 2nd ed. O'Reilly Media, Inc. 2020.

[2]    ...