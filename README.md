# quickcfg-releases

Release repository for quickcfg

Pushes to this repository will cause artifacts to be deployed to github releases.

The built artifact will use the current tag being pushed.

Examples:

* `quickcfg-0.0.1-linux-x86_64.tar.gz`
* `quickcfg-0.0.1-osx-x86_64.tar.gz`

## Making a release

Decide which version (`<version>`) you want to release.

Create a new release matching the selected `<version>` at:

https://github.com/udoprog/quickcfg-releases/releases

Create a new tag matching the `<version>`, and push:

```
$> ./make-release.sh <version>
```

Travis will build and deploy artifacts automatically.
