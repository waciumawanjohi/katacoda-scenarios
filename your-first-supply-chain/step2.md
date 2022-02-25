# Building an image

Now that your source code is available in your cluster (at that path that you
copied in the last step) we can use the cloud native buildpacks to create an
image. A full run down of cloud native buildpacks and kpack is outside the
scope of this tutorial, we'll simply use this powerful tool in the creation
of our supply chain.

# Install boilerplate files

This isn't a tutorial on kpack
([you can find that here](https://github.com/pivotal/kpack/blob/main/docs/tutorial.md))
so we've done some setup for you, including creating an object that points to an
image registry where your OCI image will be created, creating a service account
for kpack, etc. Those objects are defined in
`kpack-setup/kpack-boilerplate.yaml`{{open}}. We encourage you to trust in
those objects and focus on the kpack Image object that we'll be creating next.

# Define the object

Let's create a file defining our object.

<pre class="file" data-filename="manual-git-repo.yaml" data-target="replace">
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: GitRepository
metadata:
  name: manual-git-repo
spec:
  gitImplementation: libgit2
  ignore: ""
  interval: 1m0s
  timeout: 20s
  ref:
    branch: #TODO-set-branch
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

`kubectl apply -f example/manual-git-repo.yaml`{{execute}}

### Observe the object

The controller for the GitRepository resource is now reconciling the object. We want to get the status of the object
once that reconciliation is done.

`kubectl get gitrepository manual-git-repo -o yaml`{{execute}}

Once we observe that the status includes the following, we'll know that the controller has completed its work.
If you don't see a status on the object, wait a few moments and rerun the kubectl get:

```yaml
  conditions:
    - lastTransitionTime: <some-time>
      message: 'Fetched revision: <some-revision>'
      reason: GitOperationSucceed
      status: "True"
      type: Ready
```

The gitrepository is now exposing the most recent code on the specified branch to any resource in the cluster.
Execute the following command to get the value. Copy the value, we'll use it in just a moment:

`kubectl get gitrepository manual-git-repo -o yaml | yq .status.artifact.url`{{execute}}

Now we're ready for another kubernetes tool to turn this code into an OCI image!
