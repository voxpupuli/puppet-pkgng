# Puppet-pkgng

[![Build Status](https://travis-ci.org/voxpupuli/puppet-pkgng.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-pkgng)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/pkgng.svg)](https://forge.puppetlabs.com/puppet/pkgng)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/pkgng.svg)](https://forge.puppetlabs.com/puppet/pkgng)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/pkgng.svg)](https://forge.puppetlabs.com/puppet/pkgng)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/pkgng.svg)](https://forge.puppetlabs.com/puppet/pkgng)

The package provider that matured in this repository has been merged upstream
into the core Puppet package providers.  As of puppet 4.1, you can enjoy the
fruits of the pkgng provider without this module.  This module now remains to
manage pkg.conf, extra package repositories etc.

If you are looking to build your own PkgNG packages, you may also want to look
at the [poudriere module](https://github.com/voxpupuli/puppet-poudriere).

## Upgrading Requirements

To use the 1.x or newer version of this module, ensure that you are running
Puppet 4.1 or higher.  Any of the `pkgng_*` facts that were employed outside of
this repository should be re-evaluated.  Those facts are no longer distributed
with this module.

If you are using a Package override to specify that pkgng should be used as the
provider,  this should no longer be required as the pkgng provider is now the
default for FreeBSD.

The latest release of this module to contain the package provider is `0.4.0`.

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

By default, this module will erase user-defined repository not managed by Puppet.
To disable this behaviour you can use the example above of
setting `purge_repos_d` to false.

Disabling the FreeBSD default repository is done with:

```Puppet
pkgng::repo { 'FreeBSD':
  enabled => false,
}
```

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
mod 'pkgng', :git => 'git://github.com/xaque208/puppet-pkgng.git', :ref => '1.0.0'
```

### Installation via [Librarian-Puppet](http://librarian-puppet.com/)

Installation via Librarian-Puppet is straight forward, simply add the
following to your `Puppetfile`

```Ruby
mod 'zleslie/pkgng'
```

## Usage

Once the module is installed, you can simply install package resources.

```Puppet
package { 'curl': }
```

With multiple repositories defined, a package can be installed from a specific
repo by giving a URN locator for that repository like this.

```Puppet
pkgng::repo { 'my.own.repo': }

package { 'puppet':
  source => 'urn:freebsd:repo:my.own.repo',
}
```

If you have multiple repos providing the same package you can prefer one repo
over the other by increasing the priority.  The default priority is 0 and
higher priorities are preferred.

```Puppet
pkgng::repo { 'pkg.freebsd.org': }
pkgng::repo { 'my.own.repo':
  priority => 10,
}

package {'curl': }
```

With the above config if the 'curl' package exists in both repositories it
would be installed from my.own.repo

## Contributing

Please help make this module better.  Send pull request, file issues, be
mindful of the tests and help improve where you can.

For any provider changes, please submit those directly to core
[Puppet](https://github.com/puppetlabs/puppet).

## Thanks

Thanks to all contributors who helped mature the provider and helped it
graduate from this module into core Puppet.  Its maintenance will also require
community attention.

