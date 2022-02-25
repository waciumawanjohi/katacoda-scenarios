# A manual supply chain

You are sharp enough to write imperative code that will take your source code
and turn it into a live app running on a server. And as a kubernetes user,
you're sharp enough to see the value in transitioning from imperative code
to declarative configuration. In the following few pages, we'll use specialized
tools to do each step of the process to deploy our code.

We will use 3 kubernetes resources (you don't need any prior experience with
these)

- [fluxcd GitRepository](https://fluxcd.io/docs/components/source/gitrepositories/)
  to get code into our cluster
- [kpack Image](https://github.com/pivotal/kpack/blob/main/docs/tutorial.md)
  to turn that code into an OCI image
- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
  to actually run that image on nodes in the cluster
