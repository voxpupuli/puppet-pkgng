# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.1.0](https://github.com/voxpupuli/puppet-pkgng/tree/v4.1.0) (2023-11-06)

[Full Changelog](https://github.com/voxpupuli/puppet-pkgng/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- Add support for setting `mirror_type` to `none` [\#127](https://github.com/voxpupuli/puppet-pkgng/pull/127) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Fix EPP syntax error [\#128](https://github.com/voxpupuli/puppet-pkgng/pull/128) ([fraenki](https://github.com/fraenki))

**Merged pull requests:**

- Switch templates to EPP [\#126](https://github.com/voxpupuli/puppet-pkgng/pull/126) ([smortex](https://github.com/smortex))

## [v4.0.0](https://github.com/voxpupuli/puppet-pkgng/tree/v4.0.0) (2023-07-10)

[Full Changelog](https://github.com/voxpupuli/puppet-pkgng/compare/v3.0.0...v4.0.0)

**Breaking changes:**

- Drop Puppet 6 support [\#121](https://github.com/voxpupuli/puppet-pkgng/pull/121) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add support for Puppet 8 [\#124](https://github.com/voxpupuli/puppet-pkgng/pull/124) ([smortex](https://github.com/smortex))
- Relax dependencies version requirements [\#123](https://github.com/voxpupuli/puppet-pkgng/pull/123) ([smortex](https://github.com/smortex))
- Remove legacy `params.pp` [\#119](https://github.com/voxpupuli/puppet-pkgng/pull/119) ([smortex](https://github.com/smortex))

## [v3.0.0](https://github.com/voxpupuli/puppet-pkgng/tree/v3.0.0) (2022-09-13)

[Full Changelog](https://github.com/voxpupuli/puppet-pkgng/compare/v2.4.0...v3.0.0)

**Breaking changes:**

- Drop support for FreeBSD 11 \(EOL\) [\#114](https://github.com/voxpupuli/puppet-pkgng/pull/114) ([smortex](https://github.com/smortex))
- Drop support for Puppet 5 \(EOL\) [\#112](https://github.com/voxpupuli/puppet-pkgng/pull/112) ([smortex](https://github.com/smortex))
- Drop Puppet 4 support [\#107](https://github.com/voxpupuli/puppet-pkgng/pull/107) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Add support for FreeBSD 13 [\#115](https://github.com/voxpupuli/puppet-pkgng/pull/115) ([smortex](https://github.com/smortex))
- Add support for Puppet 7 [\#113](https://github.com/voxpupuli/puppet-pkgng/pull/113) ([smortex](https://github.com/smortex))

**Closed issues:**

- Allow modifying / disabling repos in /etc [\#105](https://github.com/voxpupuli/puppet-pkgng/issues/105)

**Merged pull requests:**

- puppet-lint: fix top\_scope\_facts warnings [\#109](https://github.com/voxpupuli/puppet-pkgng/pull/109) ([bastelfreak](https://github.com/bastelfreak))
- Allow stdlib 8.0.0 [\#108](https://github.com/voxpupuli/puppet-pkgng/pull/108) ([smortex](https://github.com/smortex))
- Fix reference to which module to install [\#104](https://github.com/voxpupuli/puppet-pkgng/pull/104) ([igalic](https://github.com/igalic))
- modulesync 3.0.0 & puppet-lint updates [\#102](https://github.com/voxpupuli/puppet-pkgng/pull/102) ([bastelfreak](https://github.com/bastelfreak))

## [v2.4.0](https://github.com/voxpupuli/puppet-pkgng/tree/v2.4.0) (2020-05-27)

[Full Changelog](https://github.com/voxpupuli/puppet-pkgng/compare/2.3.0...v2.4.0)

**Merged pull requests:**

- Allow puppetlabs/stdlib 6.x [\#99](https://github.com/voxpupuli/puppet-pkgng/pull/99) ([dhoppe](https://github.com/dhoppe))

## [2.3.0](https://github.com/voxpupuli/puppet-pkgng/tree/2.3.0) (2020-01-01)

[Full Changelog](https://github.com/voxpupuli/puppet-pkgng/compare/2.2.1...2.3.0)

**Merged pull requests:**

- Update from xaque208 modulesync\_config [\#96](https://github.com/voxpupuli/puppet-pkgng/pull/96) ([zachfi](https://github.com/zachfi))
- Update from xaque208 modulesync\_config [\#95](https://github.com/voxpupuli/puppet-pkgng/pull/95) ([zachfi](https://github.com/zachfi))

## [2.2.1](https://github.com/voxpupuli/puppet-pkgng/tree/2.2.1) (2019-02-28)

[Full Changelog](https://github.com/voxpupuli/puppet-pkgng/compare/2.2.0...2.2.1)

**Merged pull requests:**

- Update from xaque208 modulesync\_config [\#94](https://github.com/voxpupuli/puppet-pkgng/pull/94) ([zachfi](https://github.com/zachfi))

## [2.2.0](https://github.com/voxpupuli/puppet-pkgng/tree/2.2.0) (2019-02-15)

[Full Changelog](https://github.com/voxpupuli/puppet-pkgng/compare/2.1.1...2.2.0)

**Closed issues:**

- Logo proposal [\#89](https://github.com/voxpupuli/puppet-pkgng/issues/89)
- Order of operations problem with Puppet 4 [\#77](https://github.com/voxpupuli/puppet-pkgng/issues/77)

**Merged pull requests:**

- Drop old ruby [\#93](https://github.com/voxpupuli/puppet-pkgng/pull/93) ([zachfi](https://github.com/zachfi))
- facter: always use the repository as a source of package version [\#92](https://github.com/voxpupuli/puppet-pkgng/pull/92) ([olevole](https://github.com/olevole))
- Relax dependency on puppetlabs-stdlib [\#90](https://github.com/voxpupuli/puppet-pkgng/pull/90) ([smortex](https://github.com/smortex))
- Update repos before installing packages [\#88](https://github.com/voxpupuli/puppet-pkgng/pull/88) ([smortex](https://github.com/smortex))

## [2.1.1](https://github.com/voxpupuli/puppet-pkgng/tree/2.1.1) (2018-02-11)

[Full Changelog](https://github.com/voxpupuli/puppet-pkgng/compare/2.1.0...2.1.1)

**Closed issues:**

- Code not in sync with puppet Forge? [\#84](https://github.com/voxpupuli/puppet-pkgng/issues/84)

## [2.1.0](https://github.com/voxpupuli/puppet-pkgng/tree/2.2.1) (2017-07-31)
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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
