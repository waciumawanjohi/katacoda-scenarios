# Create a repo with your code

To deploy an app, you'll first need source code! Our supply chain is going
to use Cloud Native Buildpacks (CNB) to build our images. We recommend using
one
of the dozens of example apps from the
[CNB examples](https://github.com/paketo-buildpacks/samples).
This will make our build step relatively fast and assure us that we won't
run into unexpected gotchas unrelated to Cartographer.

You can see here how I've copied a golang example app into a separate repo.
- [CNB example](https://github.com/paketo-buildpacks/samples/tree/main/go/mod)
- [Copied example](https://github.com/waciumawanjohi/go-mod-example)

The code snippets in future pages will use this repo, feel free to
substitute in your own copy (which will allow you to make commits and watch
live updates to your app!).
