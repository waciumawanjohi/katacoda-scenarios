# Building an image

Now that your source code is available in your cluster (at that path that you
copied in the last step) we can use the cloud native buildpacks to create an
image. A full run down of cloud native buildpacks and kpack is outside the
scope of this tutorial, we'll simply use this powerful tool in the creation
of our supply chain.

# Install boilerplate files

This isn't a tutorial on kpack
([you can find that here](https://github.com/pivotal/kpack/blob/main/docs/tutorial.md))
so we've done some setup for you, including writing an object that points to an
image registry where your OCI image will be created, writing a service account
for kpack, etc. Those objects are defined in the files in `kpack-setup`
which we'll apply now:
`kubectl apply -f kpack-setup/`{{execute}}

Feel free to inspect the objects just created, but we encourage you to trust
in them and focus on the kpack Image object that we'll be creating next.

# Define the object

Let's create a file defining our kpack image.

`manual-image.yaml`{{open}}

As with the GitRepository object, there are values that we can predefine,
that will work for a wide array of apps. And there are some values that must
be specialized for your app.

The first thing that we'll do is specify the tag for the image that will be
created.

<pre class="file" data-filename="manual-image.yaml" data-target="append">
  tag: 0.0.0.0:5000/your-app-</pre>

We're running a local image registry (where your OCI image will be stored)
and we need to get that address now. Run the following command to find the
ip address:

`cartographer/hack/ip.py`{{execute}}

And replace the `0.0.0.0` in the images `tag` field with the ip address just
revealed.

(You may also change the `your-app` name to a name of your choosing)

Great! Now we need to tell this kpack Image object where to find your source
code. This is the value from the status of the GitRepository object you
created before. Add the following fields to the kpack Image:

<pre class="file" data-filename="manual-image.yaml" data-target="append">
  source:
    blob:
      url: </pre>

add in the url field, paste in the source code location from the
GitRepository object.

### Apply the object

We're ready; create the object in the repo!

`kubectl apply -f example/manual-image.yaml`{{execute}}

### Observe the object

The kpack controller is now reconciling the object. We want to get the
status of the object once that reconciliation is done.

`kubectl get image.kpack.io manual-image -o yaml`{{execute}}

Building the image may take a minute. Once we observe that the status includes
the following, we'll know that the controller has completed its work.

```yaml
  conditions:
    - lastTransitionTime: <some-time>
      message: 'Fetched revision: <some-revision>'
      reason: GitOperationSucceed
      status: "True"
      type: Ready
```

The kpack Image is now exposing the location of the OCI image. We can see
that location on the object's `.status.latestImage` field. As before, we'll
copy this value and use it with our next kubernetes object. You can execute
the following command:

`kubectl get image.kpack.io manual-image -o yaml | yq .status.latestImage`{{execute}}

Now let's create a deployment that uses this image!
