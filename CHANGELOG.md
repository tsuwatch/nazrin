## [2.6.1](https://github.com/tsuwatch/nazrin/compare/v2.6.0...v2.6.1)

### Fixes:

* Fix struct data accessor for `_no_fields` requests [#29](https://github.com/tsuwatch/nazrin/pull/29) - [@AMHOL](https://github.com/AMHOL)

## [2.6.0](https://github.com/tsuwatch/nazrin/compare/v2.5.0...v2.6.0)

### Features:

* Implement batch operation [#27](https://github.com/tsuwatch/nazrin/pull/27) - [@AMHOL](https://github.com/AMHOL)

## [2.5.0](https://github.com/tsuwatch/nazrin/compare/v2.4.0...v2.5.0)

### Features:

* CloudSearch data also available [#25](https://github.com/tsuwatch/nazrin/pull/25) - [@AMHOL](https://github.com/AMHOL)

* Enable accessing facets [#26](https://github.com/tsuwatch/nazrin/pull/26) - [@AMHOL](https://github.com/AMHOL)

## [2.4.0](https://github.com/tsuwatch/nazrin/compare/v2.3.0...v2.4.0)

### Features:

* Support multile domains [#23](https://github.com/tsuwatch/nazrin/pull/23) - [@totem3](https://github.com/totem3)

* Allow logger setting of Aws::CloudSearchDomain::Client [#24](https://github.com/tsuwatch/nazrin/pull/24) - [@AMHOL](https://github.com/AMHOL)

## [2.3.0](https://github.com/tsuwatch/nazrin/compare/v2.2.0...v2.3.0)

### Features:

* Dropped support for `aws-sdk` v2 [#22](https://github.com/tsuwatch/nazrin/pull/22)

## [2.2.0](https://github.com/tsuwatch/nazrin/compare/v2.1.2...v2.2.0)

### Breaking changes:

* Include `Nazrin::Searchable` instead of `Nazrin::ActiveRecord::Searchable` [#19](https://github.com/tsuwatch/nazrin/pull/19)

### Features:

* Support Mongoid [#17](https://github.com/tsuwatch/nazrin/pull/17) [#20](https://github.com/tsuwatch/nazrin/pull/20) - [@yefim](https://github.com/yefim)

## [2.1.2](https://github.com/tsuwatch/nazrin/compare/v2.1.1...v2.1.2)

### Fixes:

* Require aws-sdk gem in nazrin [#14](https://github.com/tsuwatch/nazrin/pull/14)

## [2.1.1](https://github.com/tsuwatch/nazrin/compare/v2.1.0...v2.1.1)

### Fixes:

* Fix a bug where unintended assignmenting in conditional statement [#12](https://github.com/tsuwatch/nazrin/pull/12)

## [2.1.0](https://github.com/tsuwatch/nazrin/compare/v2.0.0...v2.1.0)

### Breaking changes:

* Deprecated `Nazrin.config.debug_mode` [#11](https://github.com/tsuwatch/nazrin/pull/11)

### Features:

* Implement sandbox mode [#11](https://github.com/tsuwatch/nazrin/pull/11)

## [2.0.0](https://github.com/tsuwatch/nazrin/compare/v2.0.0.rc1...v2.0.0)

### Fixes:

* Add activesupport to dependencies ([#9](https://github.com/tsuwatch/nazrin/pull/9))

## [2.0.0.rc1](https://github.com/tsuwatch/nazrin/compare/v1.0.1...v2.0.0.rc1)

### Breaking changes:

* Extracted Kaminari support to nazrin-kaminari gem ([#7](https://github.com/tsuwatch/nazrin/pull/7))

* Extracted will_paginate support to nazrin-will_paginate gem ([#7](https://github.com/tsuwatch/nazrin/pull/7))
