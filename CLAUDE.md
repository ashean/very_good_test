# Claude Development Notes

## Project Conventions

### Pull Request Titles
- Must follow conventional commit format: `type: description`
- Available types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- Example: `feat: add reset button to counter`

### Development Workflow
- Always create feature branches (never work directly on main)
- Branch naming: `feature/description` or `fix/description`
- Run `flutter test` and `flutter analyze` before commits
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
- Build: `flutter build`