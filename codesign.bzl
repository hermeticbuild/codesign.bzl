"""Rule for signing Apple binaries with codesign."""

_TOOLCHAIN_TYPE = Label("//toolchain:toolchain_type")

def _codesign_impl(ctx):
    out = ctx.outputs.executable

    args = ctx.actions.args()
    args.add("sign")
    args.add("--entitlements-xml-file")
    args.add(ctx.file.entitlements)
    args.add("--binary-identifier")
    args.add(ctx.attr.binary_identifier)
    args.add(ctx.file.binary)
    args.add(out)

    toolchain = ctx.toolchains[_TOOLCHAIN_TYPE]

    ctx.actions.run(
        executable = toolchain.codesign,
        inputs = [
            ctx.file.binary,
            ctx.file.entitlements,
        ],
        outputs = [out],
        arguments = [args],
        mnemonic = "Codesign",
        progress_message = "Signing %{label}",
    )

    return [DefaultInfo(
        executable = out,
        files = depset([out]),
    )]

codesign = rule(
    implementation = _codesign_impl,
    attrs = {
        "binary": attr.label(allow_single_file = True, mandatory = True),
        "binary_identifier": attr.string(mandatory = True),
        "entitlements": attr.label(allow_single_file = True, mandatory = True),
    },
    executable = True,
    toolchains = [_TOOLCHAIN_TYPE],
)
