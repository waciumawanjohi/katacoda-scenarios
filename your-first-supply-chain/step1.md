# Manually create a supply chain

We'll first manually create a set of kubernetes resources that will go from code to running app in the cluster.

- a fluxcd GitRepository to get code into our cluster
- a kpack image to turn that code into an OCI image
- a deployment to actually run that image on nodes in the cluster

## GitRepository: Getting source code into your cluster

### Define the object

First let's create a file defining our object.

<pre class="file" data-filename="manual-git-repo.yaml" data-target="replace">
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: GitRepository
metadata:
  name: manual-git-repo
spec:
  gitImplementation: libgit2
  ignore: ""
  interval: 1m0s
  ref:
    branch: #TODO-set-branch
  timeout: 20s
  url: #TODO-set-repo-url
</pre>

Now let's choose an app to deploy. We want to use code that will behave well with our build step, so I recommend that
you copy one of the dozens of example apps from the [Cloud Native Buildpacks examples](https://github.com/paketo-buildpacks/samples).

We'll replace the `TODO-set-branch` and `TODO-set-repo-url` with the appropriate values. Feel free to copy in the values below.

<pre class="file" data-filename="manual-git-repo.yaml" data-target="insert"  data-marker="#TODO-set-branch">
main
</pre>

<pre class="file" data-filename="manual-git-repo.yaml" data-target="insert"  data-marker="#TODO-set-repo-url">
https://github.com/kontinue/hello-world
</pre>

### Apply the object

Let's create the object in the repo:

`kubectl apply -f manual-git-repo.yaml`{{execute}}

### Observe the object

The controller for the GitRepository resource is now reconciling the object. We want to get the status of the object
once that reconciliation is done.

`kubectl get gitrepository manual-git-repo`{{execute}}

Once we observe that the status includes the following, we'll know that the controller has completed its work:

```yaml
  conditions:
    - lastTransitionTime: <some-time>
      message: 'Fetched revision: <some-revision>'
      reason: GitOperationSucceed
      status: "True"
      type: Ready
```

The gitrepository is now exposing the most recent code on the specified branch to any resource in the cluster.
Let's copy that value to our clipboard:

`kubectl get gitrepository manual-git-repo | yq .status.artifact.url | pbcopy`{{execute}}

Now we're ready for another kubernetes tool to turn this code into an OCI image!
