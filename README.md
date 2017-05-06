# Scenario 1 of Reproducible FreeBSD Jail Setup Project

Jacob McDonald
Revision 170505a-yottabit

All scenarios are also available in an easy-to-read [Google Doc][gdoc].

## Problem Statement

As with any operating system, when used interactively, it is possible for a FreeBSD Jail to become misconfigured, crufty, outdated, and not work as expected. Additionally, FreeBSD kernel upgrades can affect the package compatibility that are installed in the Jail, and reverting the Jail dataset to an earlier snapshot would not alleviate this problem.

## Assumptions

* User has basic-to-intermediate UNIX experience

* User knows how to use the referenced applications

* User knows how to create a standard FreeBSD Jail from an OS shell or FreeNAS UI

* User knows how to enter the Jail from an OS shell or FreeNAS UI

* User knows how to create ZFS datasets from an OS shell or FreeNAS UI

* User knows how to link ZFS datasets into Jails from an OS shell or FreeNAS UI

* User knows how to create ZFS dataset snapshots, if needed, from an OS shell or FreeNAS UI

## Solution

Create configuration scripts for Jails in a similar fashion to Docker Containers, so that a Jail can be destroyed and recreated quickly in order to fix or upgrade the Jail environment.

Rather than keep configuration data directly in the Jail filesystem, link in a dataset where the configuration script, and any required configuration data, can reside. Link in datasets that are required for the purpose of the Jail.

One could fully automate the creation of the Jail itself, but in this scenario we will rely on the FreeNAS UI to manage the Jails, and use configuration scripts inside the Jail itself to complete the setup.

It’s also possible to take this methodology a couple steps further. Namely:

* Remove unnecessary packages from the default Jail environment, and

* Run applications directly from init so that the Jail will shutdown when the application finishes. The user could therefore schedule applications to run as needed from the host OS cron, even more like a Docker Container environment.

* Left as an exercise for the reader.

(Side note: scripting in Bourne *sh* is much easier when one realizes it isn’t *csh*. 😐 Also, this is 1979 Bourne shell, *sh*—not that newfangled 1989 Bourne-again shell, *bash*. It *should* be compatible with *dash*, the default */bin/sh* in GNU/Linux, but ymmv as I have not tested it.)

### Scenario 1: Resilio Sync for distributed synchronization of data

Create a standard FreeBSD jail. Link in the persistent configuration dataset, `/config` in this case. Run the configuration script, `install-sync.sh` in this case.

[//]:

  [gdoc]: https://docs.google.com/document/d/1LSr3J6hdnCDQHfiH45K3HMvEqzbug7GeUeDa_6b_Hhc
