---
layout: page
title: Documentation
permalink: /docs/
---



## Motivation

I have been a happy customer of the [DynDns.org][dyndns.org] Service for over 15 years now. I think they did a great job pushing this kind of service so far that every consumer router nowadays can update DNS entry in an easy and standardised fashion. They have great features and in is easy to use.

I had to learn that my [favorite router platform PfSense][pfsense] not only supports DynDns Style updates but also [RFC2136 compliant updates][RFC2136WikipediaEn].

There were some points that were appealing to me:

1. I could run a dynamic zone on my own name server (e.g. [ISC Bind9][iscbind9], [unbound][unbound]) which is under my control.
2. Unlimited number of host names, no plans, no renewals, etc.
1. Using some "well known", standardized implementation of a mechanism incorporating cryptographic methods for authentication.
1. At least bind9 being able to not only authenticate (your user account is authorised to change all your host names and has access to the whole user account), but also authorises users flexibly (you can manage ACLs) without providing access to your installation.
1. As long as I am running a name server, it´s a "free add on" (free as in beer).
1. Using my domains and being able to mix static names with dynamic ones.

There also is a downside:

1. Text file driven configuration, so no web-GUI for your unnerdy boss and colleagues.
1. The update only works with interfaces having the IP address, updates behind NAT might give wrong results out of the box.
1. RFC2136 updates are rarely supported on consumer grade routers.



[dyndns.org]: http://dyn.com/dns/
[pfsense]: https://www.pfsense.org/
[RFC2136WikipediaEn]: https://en.wikipedia.org/wiki/Dynamic_DNS#Standards-based_dynamic_DNS_update
[iscbind9]: https://www.isc.org/downloads/bind/
[unbound]: https://www.unbound.net/
