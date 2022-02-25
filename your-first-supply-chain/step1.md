# Getting source code into your cluster

You'll use a GitRepository to expose your source code in the cluster.

# Define the object

First let's open the file defining our GitRepository object.

`manual-git-repo.yaml`{{open}}

We'll replace the `TODO-set-branch` and `TODO-set-repo-url` with the values
discussed on the last page.

<pre class="file" data-filename="manual-git-repo.yaml" data-target="insert"  data-marker="#TODO-set-branch">
main
</pre>

<pre class="file" data-filename="manual-git-repo.yaml" data-target="insert"  data-marker="#TODO-set-repo-url">
https://github.com/waciumawanjohi/go-mod-example
</pre>

# Apply the object

Let's create the object in the repo:

`kubectl apply -f example/manual-git-repo.yaml`{{execute}}

# Observe the object

The controller for the GitRepository resource is now reconciling the object. We
want to get the status of the object once that reconciliation is done.

`kubectl get gitrepository manual-git-repo -o yaml`{{execute}}

Once we observe that the status includes the following, we'll know that the
controller has completed its work. If you don't see a status on the object, wait
a few moments and rerun the kubectl get:

```yaml
  conditions:
    - lastTransitionTime: <some-time>
      message: 'Fetched revision: <some-revision>'
      reason: GitOperationSucceed
      status: "True"
      type: Ready
```

The gitrepository is now exposing the most recent code on the specified branch
to any resource in the cluster. Execute the following command to get the value.
Copy the value, we'll use it in just a moment:

`kubectl get gitrepository manual-git-repo -o yaml | yq .status.artifact.url`{{execute}}

Now we're ready for another kubernetes tool to turn this code into an OCI image!
