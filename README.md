# Puppet-pkgng

[![Puppet Forge](https://img.shields.io/puppetforge/v/zleslie/pkgng.svg)]() [![Build Status](https://travis-ci.org/xaque208/puppet-pkgng.svg?branch=master)](https://travis-ci.org/xaque208/puppet-pkgng)

A package provider for FreeBSD's PkgNG package manager.

This module contains the provider as well as some implementation around
configuring the `pkg.conf` file.  If you are building your own PkgNG packages,
you may also want to look at the [poudriere
module](https://github.com/xaque208/puppet-poudriere).

## Installation

The easiest way to install is to install from the forge.

```
puppet module install zleslie/pkgng
```

Then to configure your system to use PkgNG with all default settings, a
simple include will do.

```Puppet
include pkgng
```

You may wish to override settings though, to do this simply use it as a class:

```Puppet
class { 'pkgng':
  purge_repos_d => false,
  options       => [
    'PKG_ENV : {',
    ' http_proxy: "http://proxy:3128"',
    '}',
  ],
}
```

By default, this module will erase the default repository and you'll want to
define some. To disable this behaviour you can use the example above of
setting `purge_repos_d` to false.

Using specific repositories is as simple as a Puppet resource.

```Puppet
pkgng::repo { 'pkg.freebsd.org': }  # You'll want this one!
pkgng::repo { 'my.own.repo': }      # You can then specify more...
```

### Installation via [R10K](https://github.com/adrienthebo/r10k)

You can also clone this repo to somewhere in your modulepath, or use something
like [r10k](https://github.com/adrienthebo/r10k) to deploy your modules.  R10k
is sweet.  For those not familiar, check out [Finch's blog
post](http://somethingsinistral.net/blog/rethinking-puppet-deployment/) on the
subject of module deployment.

To track the git repository, a line in your Puppetfile that looks something
like the following should get you started.

```Ruby
mod 'pkgng', :git => 'git://github.com/xaque208/puppet-pkgng.git', :ref => '0.2.0'
```

### Installation via [Librarian-Puppet](http://librarian-puppet.com/)

Installation via Librarian-Puppet is straight forward, simply add the
following to your `Puppetfile`

```Ruby
mod 'zleslie/pkgng'
```

## Usage

Once you have the module installed, you can use it by simply adding a site
default in site.pp that looks like this.

```Puppet
Package {
  provider => pkgng
}
```

Now every package that you install will use the PkgNG provider.

With multiple repositories defined, a package can be installed from a specific
repo by giving a URN locator for that repository like this.

```Puppet
pkgng::repo { 'my.own.repo': }

package { 'puppet':
  source => 'urn:freebsd:repo:my.own.repo',
}
```

If you have multible repos provinding the same package you can prefer one repo 
over the other by increasing the priority.  The dafult priority is 0 and higher 
priorities are prefered

```Puppet
pkgng::repo { 'pkg.freebsd.org': }  
pkgng::repo { 'my.own.repo':
  priority => 10,
}

package {'wget': }
```

With the above config if the wget package exists in both repositories it would be installed from my.own.repo

## Contributing

Please help make this module better.  Send pull request, file issues, be
mindful of the tests and help improve where you can.

