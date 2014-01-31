Puppet-pkgng
===

[![Build Status](https://travis-ci.org/xaque208/puppet-pkgng.png)](https://travis-ci.org/xaque208/puppet-pkgng)


A package provider for FreeBSD's PkgNG package manager.

This module contains the provider as well as some implementation around
configuring the pkg.conf file.  If you are building your own PkgNG packages,
you may also want to look at my [poudriere
module](https://github.com/xaque208/puppet-poudriere).

## Installation

The easiest way to install is to install from the forge.

    puppet module install zleslie/pkgng

Then to configure your system to use a PkgNG, a simple include will do.

    include pkgng

### Installation via r10K

You can also clone this repo to somewhere in your modulepath, or use something
like [r10k](https://github.com/adrienthebo/r10k) to deploy your modules.  R10k
is sweet.  For those not familiar, check out [Finch's blog
post](http://somethingsinistral.net/blog/rethinking-puppet-deployment/) about
it.

### Installation via [Librarian-Puppet](http://librarian-puppet.com/)

Installation via Librarian-Puppet is straight forward, simply add the
following to your `Puppetfile`

```
mod 'zleslie/pkgng'
```

## Usage

Once you have the module installed, you can use it by simply adding a site
default in site.pp that looks like this.

    Package {
      provider => pkgng
    }

Now every package that you install will use the PkgNG provider.


