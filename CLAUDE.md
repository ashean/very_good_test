# Claude Development Notes

## Project Conventions

### Pull Request Titles
- Must follow conventional commit format: `type: description`
- Available types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- Example: `feat: add reset button to counter`

### Development Workflow
- Always create feature branches (never work directly on main)
- Branch naming: `feature/description` or `fix/description`
- Run pre-commit checks before commits:
  - `flutter test` - All tests must pass
  - `flutter analyze lib test` - No lint issues
  - `dart format --line-length 80 --set-exit-if-changed lib test` - Proper formatting
- All tests must pass before merging

### Branch Cleanup After Merge
```bash
git checkout main
git pull origin main
git branch -d feature/branch-name
git remote prune origin
```

### Testing
- Use `flutter test` to run all tests
- Use `flutter analyze lib test` for linting
- Follow existing test patterns (bloc_test for cubits, widget tests for UI)

## Coding Standards

### Import Organization
- **Package imports first** (alphabetical): `package:flutter/`, `package:drift/`, etc.
- **Relative imports last** (alphabetical): `package:my_app/`
- **Blank line** between package and relative imports
- **Use package imports** for all files in `lib/` directory (never use relative `../` imports)

Example:
```dart
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

import 'package:my_app/persistence/submission_repository.dart';
import 'package:my_app/submissions/cubit/submissions_cubit.dart';
```

### Error Handling
- **Use specific exception types**: `on Exception catch (e)` instead of `catch (e)`
- Avoid generic `catch` clauses without type specification

Example:
```dart
try {
  await someAsyncOperation();
} on Exception catch (e) {
  // Handle specific exception
}
```

### File Formatting
- **Always end files with newline** (add blank line at end)
- **80 character line limit** - break long lines appropriately
- **Use const constructors** when possible

### Drift/Database Setup
- Use `Uri.parse()` for web asset locations, not `AssetLocation()`
- Remove `const` from `DriftWebOptions` constructor (not const)
- Use double parentheses for table column definitions: `integer().autoIncrement()()`

### Common Lint Fixes
- `always_use_package_imports` - Use `package:my_app/` imports
- `avoid_catches_without_on_clauses` - Specify exception types
- `directives_ordering` - Order imports correctly
- `lines_longer_than_80_chars` - Break long lines
- `eol_at_end_of_file` - Add newline at end (use `dart format <file>` to fix)

## Commands
- Test: `flutter test`
- Analyze: `flutter analyze lib test`
- Format: `dart format --line-length 80 --set-exit-if-changed lib test`
- **Fix specific formatting issues**: `dart format <file>` (useful for `eol_at_end_of_file` errors)
- Build: `flutter build`
- **Web with persistent database**: `flutter run --target lib/main_development.dart -d chrome --web-port=8080`

### Web Database Testing
For testing database persistence on web (Drift/SQLite):
- **Use fixed port**: `--web-port=8080` ensures consistent origin
- **Data persists** between browser sessions on same port
- **Random ports** (default) create new storage domains each run

## Pre-commit Checklist
Run these commands before committing:
```bash
flutter test
flutter analyze lib test  
dart format --line-length 80 --set-exit-if-changed lib test
```