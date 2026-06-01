"""Internal definitions for the codesign toolchain."""

def _codesign_toolchain_impl(ctx):
    codesign = ctx.file.codesign

    return [
        platform_common.ToolchainInfo(
            codesign = codesign,
        ),
        DefaultInfo(files = depset([codesign])),
    ]

codesign_toolchain = rule(
    implementation = _codesign_toolchain_impl,
    attrs = {
        "codesign": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
    },
)

def declare_codesign_toolchains():
    """Declares the prebuilt codesign toolchains."""
    for os, cpu, platform_os, platform_cpu in [
        ("darwin", "arm64", "macos", "aarch64"),
        ("darwin", "amd64", "macos", "x86_64"),
        ("linux", "arm64", "linux", "aarch64"),
        ("linux", "amd64", "linux", "x86_64"),
        ("windows", "arm64", "windows", "aarch64"),
        ("windows", "amd64", "windows", "x86_64"),
    ]:
        name = "codesign_%s_%s_toolchain" % (os, cpu)
        impl_name = name + "_impl"

        codesign_toolchain(
            name = impl_name,
            codesign = "@codesign_%s_%s//file" % (os, cpu),
        )

        native.toolchain(
            name = name,
            exec_compatible_with = [
                "@platforms//cpu:" + platform_cpu,
                "@platforms//os:" + platform_os,
            ],
            toolchain = impl_name,
            toolchain_type = ":toolchain_type",
            visibility = ["//visibility:public"],
        )
