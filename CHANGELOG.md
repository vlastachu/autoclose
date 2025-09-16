## 1.0.4

- The autoclose_bloc package now depends on autoclose_flutter, which re-exports all APIs from autoclose. You only need to add autoclose_bloc to access all features from both autoclose_bloc and autoclose_flutter (and autoclose).
- The autoclose_flutter package also re-exports autoclose, so if you don't need Bloc support, you can use autoclose_flutter directly for full access to autoclose features.
- Updated minimum Dart SDK version to >=3.2.0.
- Updated bloc dependency to '>=8.0.0 <10.0.0'.
- Fixed and improved imports, formatting, and code structure.
- Added and updated linting rules.
- Improved and reformatted tests.
- Minor fixes and refactoring.


## 1.0.3

- Add CloserChangeNotifier which provides Closer context in ChangeNotifier and ValueNotofier class.


## 1.0.2

- Support Flutter 3.22.0
- [Declare vm_service as a dev dependency](https://github.com/vlastachu/autoclose/pull/4)

## 1.0.1

- Update ReadMe and bump dart sdk version

## 1.0.0

- Initial version.