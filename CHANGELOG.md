## 1.6.0

* dart2 only, no websql yet

## 1.5.0

* Dart2 compatible (except websql shim)
* Depends on sembast 1.7.0

## 1.4.2

* Add `implicit-cast: false` support

## 1.4.0

* Depends on sembast 1.4.0

## 1.3.6

* Add IdbFactory.cmp

## 1.3.5

* Simulate multistore transaction on Safari

## 1.3.3

* Add support for import/export (sembast export format)
* Fix timing to mimic IE limitation
* Add workaround for transaction bug in sdk 1.13

## 1.3.2

* Fix implementation for IE/Edge where the transaction life-cycle is shorter

## 1.3.1

* Add support for ObjectStore.deleteIndex

## 1.2.1

* Fix openCursor for Index that included null key before (sembast)
* Travis test integration

## 1.0.0

* Initial revision 