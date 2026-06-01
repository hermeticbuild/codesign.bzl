# codesign.bzl

`codesign.bzl` provides a hermetic Bazel rule for signing Apple binaries.

It wraps the `rcodesign` binary from the [`apple-codesign`](https://crates.io/crates/apple-codesign) project and ships prebuilt binaries for macOS, Linux, and Windows. That means you can sign Mach-O binaries from any supported execution platform without depending on Apple's `/usr/bin/codesign` being installed on the machine running Bazel.

This is useful when you want:

- reproducible codesigning actions in Bazel
- remote execution for Apple packaging pipelines
- codesigning from Linux or Windows build workers
- a toolchain-backed rule instead of ad hoc `genrule` shelling out to host tools

## Setup

Add the module to your `MODULE.bazel` and register the prebuilt toolchains:

```starlark
bazel_dep(name = "codesign.bzl", version = "0.0.1")

register_toolchains("@codesign.bzl//toolchain:all")
```

## Usage

Load the rule:

```starlark
load("@codesign.bzl", "codesign")
```

Then use it to sign a binary:

```starlark
codesign(
    name = "signed_app",
    binary = ":unsigned_app",
    binary_identifier = "com.example.myapp",
    entitlements = "entitlements.plist",
)
```

The rule produces a signed executable target named `signed_app`.

## Attributes

`binary`
: The unsigned Mach-O binary to sign.

`binary_identifier`
: The bundle or binary identifier to embed in the signature, for example `com.example.myapp`.

`entitlements`
: An XML entitlements plist to apply while signing.

