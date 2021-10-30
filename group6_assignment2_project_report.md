![Text Description automatically generated with low confidence](media/be19bac2a81b8e91a68e169a7405bda8.png)

Linnaeus University

Faculty of Technology – Department of Computer Science

**2DV517 - Deployment Infrastructures**

**Examination 2**

![](media/6feca2c8054bb5f2891521af279d80c9.png)

Students:

Tomas Marx-Raacz von Hidvég (tendn09)

Susanna Persson (sp222xw)

Dennis Demir (dd222gc)  
Julia Perlkvist (jp223es)

Group: 6

INTRODUCTION
============

This document aims to record the planning and execution of the course 2dv517
group project. It will record how the plan was devised, how it changed and why.
It will also record in which way the work was done and divided throughout the
allotted time schedule for the project.

Furthermore, within this document we will also include references to theoretical
works regarding patterns that we followed, both by accident and by design.

THE WORK
========

The initial planning
--------------------

Now after having the initial meeting with the group, it became apparent that
none of us had experience with working with any of the automation tools, except
Kubernetes which is rather a tool for dividing an infrastructure into
containers.

Spurred by a statement in an instructional video in the course 1dv032 minted by
the faculty prefect Morgan Ericsson that you could do all pieces of the puzzle
with Ansible, the decision was taken to explore if this assignment could be
undertaken wholly through Ansible.

As for the general structure of the setup the choice was taken to go for a
traditional VM setup instead of a container setup through Kubernetes due to the
limited prior experience the group had of automation tools. This decision was to
lower the risk of the task becoming too overwhelming.

The above-mentioned setup was divided into a network, subnet and router followed
by eight virtual machines:

| VM                                       | Amount |
|------------------------------------------|--------|
| Wordpress hosts servers                  | 3      |
| MySQL servers                            | 2      |
| NFS file sharing server                  | 1      |
| NginX internal and external loadbalancer | 1      |
| Prometheus/Grafana monitoring server     | 1      |

![Chart Description automatically generated with medium confidence](media/32d1a5d4d834e14034c16e3892782934.jpg)

Exploratory work and preparation
--------------------------------

We started off the project by familiarizing ourselves with the tools and the
contents of the website as it existed in its current state. For this, half of
the group attempted to set up the old version of the website to gain an
understanding of its different components and the steps involved in the setup,
while the other half of the group began studying Ansible.  
  
Since none of us had prior experience with Ansible or Terraform aside from
reading about them in the prior assignment, we felt it was useful to have some
group members to start learning the tools while others studied the
infrastructure so that we then could share our new knowledge with each other and
combine our understanding of the website with knowledge about how to automate
the setup.  
  
Of course, manual setup is a good first step to take before automating in order
to figure out the steps involved and ensure that they work as intended. A bash
script
([link](https://github.com/DennisDemir24/2DV517-assignment2/blob/main/bash_scripts/lamp_install_with_backup.sh))
was created for the initial setup of the old version of the website which gave
some idea of what to do as a basis for then expanding and creating the new
infrastructure and automating it.

Workflow - trial, error and progress
------------------------------------

Our initial plan had been to rely on Ansible for automation as it seemed to be
capable of achieving everything we needed, so that’s the route we went at first.
Although we made decent progress with Ansible, especially with guidance from the
previously created bash script, we encountered some issues and eventually we let
go of the idea of relying on Ansible ([old files from initial
attempt](https://github.com/DennisDemir24/2DV517-assignment2/tree/main/Ansible/unused_files))
and agreed to instead use Terraform for the OpenStack side of things with
networks and instances ([Terraform
folder](https://github.com/DennisDemir24/2DV517-assignment2/tree/main/Terraform))
while using Ansible for the rest ([Ansible
folder](https://github.com/DennisDemir24/2DV517-assignment2/tree/main/Ansible)).  
  
For a while we wanted to have a bastion host as a point of entry to the network,
as we had previously used jump machines in system administration courses and
thought this could be useful. However we struggled a lot with making this work
properly, and eventually decided to drop the idea before pouring too much time
and effort into it that might be better used elsewhere.

After making progress with Ansible and Terraform we started to consider the
monitoring aspect. For this we decided that we were going to use Prometheus
([folder](https://github.com/DennisDemir24/2DV517-assignment2/tree/main/Ansible/roles/prometheus)),
and we also decided to use Grafana
([folder](https://github.com/DennisDemir24/2DV517-assignment2/tree/main/Ansible/roles/grafana))
alongside it to present the data from Prometheus. Although we didn’t
particularly have experience with monitoring, we had been introduced to
Prometheus in a previous course and therefore felt that it was a good tool to
choose since we had some sort of starting point for it.

Patterns
--------

Immutable server
----------------

Immutable server, as described by Kief Morris [1], is where a server’s
configuration is never changed, but rather new versions are created to replace
old versions. This avoids potential risks of changing running servers, while
also allowing you to make sure that the new server works as intended before
removing the previous version. This pattern requires strong automation, but
since we are overall focusing a lot on automation in this task this should not
be a problem.

Push server configuration
-------------------------

Push server configuration, as described by Morris [1], 

Bibliography
============

[1] K. Morris, *Infrastructure as Code*, 2nd ed. O'Reilly Media, Inc. 2020.

[2] ...
