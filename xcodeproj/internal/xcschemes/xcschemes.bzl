"""Module for defining custom Xcode schemes (`.xcscheme`s)."""

load("//xcodeproj/internal:memory_efficiency.bzl", "FALSE_ARG", "TRUE_ARG")

# Scheme

def _scheme(name, *, profile = "same_as_run", run = None, test = None):
    """Defines a custom scheme.

    Args:
        name: The name of the scheme.
        profile: A value returned by `xcschemes.profile`, or the string
            `"same_as_run"`. If `"same_as_run"`, the same targets will be built
            for the Profile action as are built for the Run action (defined by
            `xcschemes.run`). If `None`, `xcschemes.profile()` will be used,
            which means no targets will be built for the Profile action.
        run: A value returned by `xcschemes.run`. If `None`, `xcschemes.run()`
            will be used.
        test: A value returned by `xcschemes.test`. If `None`,
            `xcschemes.test()` will be used.
    """
    if not name:
        fail("Name must be provided to `xcschemes.scheme`.")

    return struct(
        name = name,
        profile = profile,
        run = run,
        test = test,
    )

# Actions

def _profile(
        *,
        args = [],
        build_targets = [],
        env = {},
        env_include_default = True,
        launch_target = None,
        use_run_args_and_env = None,
        xcode_configuration = None):
    if use_run_args_and_env == None:
        use_run_args_and_env = not (args or env)

    return struct(
        args = args,
        build_targets = build_targets,
        env = env,
        env_include_default = env_include_default,
        launch_target = launch_target,
        use_run_args_and_env = use_run_args_and_env,
        xcode_configuration = xcode_configuration or "",
    )

def _run(
        *,
        args = [],
        build_targets = [],
        diagnostics = None,
        env = {},
        env_include_default = True,
        launch_target = None,
        xcode_configuration = None):
    return struct(
        args = args,
        build_targets = build_targets,
        diagnostics = diagnostics,
        env = env,
        env_include_default = env_include_default,
        launch_target = launch_target,
        xcode_configuration = xcode_configuration or "",
    )

def _test(
        *,
        args = [],
        build_targets = [],
        diagnostics = None,
        env = {},
        env_include_default = True,
        test_targets = [],
        use_run_args_and_env = None,
        xcode_configuration = None):
    if use_run_args_and_env == None:
        use_run_args_and_env = not (args or env)

    return struct(
        args = args,
        build_targets = build_targets,
        diagnostics = diagnostics,
        env = env,
        env_include_default = TRUE_ARG if env_include_default else FALSE_ARG,
        test_targets = test_targets,
        use_run_args_and_env = TRUE_ARG if use_run_args_and_env else FALSE_ARG,
        xcode_configuration = xcode_configuration or "",
    )

# Targets

def _launch_target(
        label,
        *,
        extension_host = None,
        library_targets = [],
        post_actions = [],
        pre_actions = [],
        target_environment = None,
        working_directory = None):
    if not label:
        fail("Label must be provided to `xcschemes.launch_target`.")

    return struct(
        extension_host = extension_host or "",
        label = label,
        library_targets = library_targets,
        post_actions = post_actions,
        pre_actions = pre_actions,
        target_environment = target_environment,
        working_directory = working_directory or "",
    )

def _library_target(label, *, post_actions = [], pre_actions = []):
    if not label:
        fail("Label must be provided to `xcschemes.library_target`.")

    return struct(
        label = label,
        post_actions = post_actions,
        pre_actions = pre_actions,
    )

def _test_target(
        label,
        *,
        enabled = True,
        library_targets = [],
        post_actions = [],
        pre_actions = [],
        target_environment = None):
    if not label:
        fail("Label must be provided to `xcschemes.test_target`.")

    return struct(
        enabled = TRUE_ARG if enabled else FALSE_ARG,
        label = label,
        library_targets = library_targets,
        post_actions = post_actions,
        pre_actions = pre_actions,
        target_environment = target_environment,
    )

def _top_level_build_target(
        label,
        *,
        extension_host = None,
        library_targets = [],
        post_actions = [],
        pre_actions = [],
        target_environment = None):
    if not label:
        fail("Label must be provided to `xcschemes.top_level_build_target`.")

    return struct(
        extension_host = extension_host or "",
        include = True,
        label = label,
        library_targets = library_targets,
        post_actions = post_actions,
        pre_actions = pre_actions,
        target_environment = target_environment,
    )

def _top_level_anchor_build_target(
        label,
        *,
        extension_host = None,
        library_targets,
        target_environment = None):
    if not label:
        fail(
            """\
Label must be provided to `xcscheme.top_level_anchor_build_target`.
""",
        )
    if not library_targets:
        fail(
            """\
`library_targets` must be non-empty for `xcscheme.top_level_anchor_build_target`
""",
        )

    return struct(
        extension_host = extension_host or "",
        include = False,
        label = label,
        library_targets = library_targets,
        post_actions = [],
        pre_actions = [],
        target_environment = target_environment,
    )

# `pre_post_actions`

def _build_script(title, *, order = None, script_text):
    return struct(
        for_build = True,
        order = order,
        script_text = script_text,
        title = title,
    )

def _launch_script(title, *, order = None, script_text):
    return struct(
        for_build = False,
        order = order,
        script_text = script_text,
        title = title,
    )

_pre_post_actions = struct(
    build_script = _build_script,
    launch_script = _launch_script,
)

# Other

def _arg_or_env(value, *, enabled = True):
    return struct(
        enabled = TRUE_ARG if enabled else FALSE_ARG,
        value = value,
    )

def _diagnostics(
        *,
        address_sanitizer = False,
        thread_sanitizer = False,
        undefined_behavior_sanitizer = False):
    if address_sanitizer and thread_sanitizer:
        fail("Address Sanitizer cannot be used together with Thread Sanitizer.")

    return struct(
        address_sanitizer = TRUE_ARG if address_sanitizer else FALSE_ARG,
        thread_sanitizer = TRUE_ARG if thread_sanitizer else FALSE_ARG,
        undefined_behavior_sanitizer = (
            TRUE_ARG if undefined_behavior_sanitizer else FALSE_ARG
        ),
    )

# API

xcschemes = struct(
    arg = _arg_or_env,
    diagnostics = _diagnostics,
    env = _arg_or_env,
    launch_target = _launch_target,
    library_target = _library_target,
    pre_post_actions = _pre_post_actions,
    profile = _profile,
    run = _run,
    scheme = _scheme,
    test = _test,
    test_target = _test_target,
    top_level_anchor_build_target = _top_level_anchor_build_target,
    top_level_build_target = _top_level_build_target,
)
