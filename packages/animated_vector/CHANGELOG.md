## 0.2.0

- Added more docs to classes and methods
- Allowed web platform to be recognized by removing direct dependencies to dart:isolate (`AnimatedVectorData.renderAnimation`) and dart:io (`AnimatedVectorData.loadFromFile`)
- `AnimatedVectorData.loadFromFile` will throw `UnsupportedError` on platforms that don't support dart:io (one such platform is web)
- Make `AnimatedVectors` abstract final and privatize constructor

## 0.1.0

Initial package release
