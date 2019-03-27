## Unreleased
 -

## 2017-07-31 2.1.0
### Summary
This release contains new facts about the state of the package updates and vulnerabilities, nested under 'pkg_*'.

## 2017-07-29 2.0.0
### Summary
This release contains some cleanup in manifest, approach, and testing.

* Recommend adding FreeBSD repo to avoid purging, see README
* Improve testing infrastructure from module_sync to behave like other modules
* Drop old manifest code that was required in early versions of pkgng

## 2016-10-28 1.2.0
### Summary
This release contains updates to testing, and adds support for managing repo
signing keys and fingerprints.


## 2016-05-22 1.1.1
### Summary
This release contains updates to testing.

#### Testing
 - Drop guard from Gemfile

## 2016-05-22 1.1.0
### Summary
This release contains an initial changelog as well as default pkg changes.

#### Features
  - Begin changelog
  - Include default aliases in pkg.conf(5)

## 2016-04-04 1.0.0
### Summary
This release contains notable changes to the modules functionality.

#### Noteworthy changes
  - Drop support for Puppet3
  - Puppet4 support provided by the sysutils/puppet4 port
  - Testing and documentation improvements
