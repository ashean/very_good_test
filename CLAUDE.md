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

## Commands
- Test: `flutter test`
- Analyze: `flutter analyze lib test`
- Format: `dart format --line-length 80 --set-exit-if-changed lib test`
- Build: `flutter build`

## Pre-commit Checklist
Run these commands before committing:
```bash
flutter test
flutter analyze lib test  
dart format --line-length 80 --set-exit-if-changed lib test
```