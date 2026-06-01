set -eux

#bazel build --remote_header=x-buildbuddy-api-key="$BUILDBUDDY_API_KEY" //prebuilt:for_all_platforms
# Windows cross-compilation doesn't work with current toolchains...
bazel build //prebuilt:for_all_platforms

copy_out() {
    src="$(bazel cquery --output=files "$1")"
    cp "$src" "$2${3:-}"
}

copy_out //prebuilt:for_aarch64-unknown-linux-musl codesign_linux_arm64
copy_out //prebuilt:for_x86_64-unknown-linux-musl codesign_linux_amd64
copy_out //prebuilt:for_aarch64-apple-darwin codesign_darwin_arm64
copy_out //prebuilt:for_x86_64-apple-darwin codesign_darwin_amd64
copy_out //prebuilt:for_aarch64-pc-windows-msvc codesign_windows_arm64 .exe
copy_out //prebuilt:for_x86_64-pc-windows-msvc codesign_windows_amd64 .exe

shasum -a 256 codesign_* > SHA256.txt
