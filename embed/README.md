# Embed

Working in progress :construction:

## FAQ

### I edited my json file to be embeded, but the embedded value does't be updated even if reruning build_runner

Clear the cache and run `build_runner` again.

```shell
dart pub run build_runner clean && dart pub run build_runner build
```

If you are still having the problem, try this:

```shell
flutter clean && dart pub run build_runner build
```
