#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# Argument provided by the reusable release workflow.
TAG=$1
VERSION=${TAG:1}
PREFIX="codesign.bzl-${VERSION}"
ARCHIVE="codesign.bzl-${TAG}.tar.gz"

# NB: configuration for 'git archive' is in /.gitattributes
git archive --format=tar --prefix="${PREFIX}/" "${TAG}" | gzip > "${ARCHIVE}"

cat << EOF
## Add to your \`MODULE.bazel\` file:

\`\`\`starlark
bazel_dep(name = "codesign", version = "${VERSION}")
\`\`\`

Register the toolchains you want to use:

\`\`\`starlark
register_toolchains("@codesign//toolchain:all")
\`\`\`
EOF

