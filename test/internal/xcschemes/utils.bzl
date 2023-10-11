"""Utility test functions for xcshemes tests."""

def _dict_of_dicts_to_arg_env_infos(dict_of_dicts):
    return {
        k: struct(
            enabled = d["enabled"],
            value = d["value"],
        )
        for k, d in dict_of_dicts.items()
    }

def _dict_to_diagnostics_info(d):
    return struct(
        address_sanitizer = d["address_sanitizer"],
        thread_sanitizer = d["thread_sanitizer"],
        undefined_behavior_sanitizer = d["undefined_behavior_sanitizer"],
    )

def _dict_to_launch_target_info(d):
    return struct(
        extension_host = d["extension_host"],
        id = d["id"],
        post_actions = _dicts_to_pre_post_action_infos(d["post_actions"]),
        pre_actions = _dicts_to_pre_post_action_infos(d["pre_actions"]),
        working_directory = d["working_directory"],
    )

def _dict_to_profile_info(d):
    return struct(
        args = _dicts_to_arg_env_infos(d["args"]),
        build_targets = _dicts_to_build_target_infos(d["build_targets"]),
        env = _dict_of_dicts_to_arg_env_infos(d["env"]),
        env_include_default = d["env_include_default"],
        launch_target = _dict_to_launch_target_info(d["launch_target"]),
        use_run_args_and_env = d["use_run_args_and_env"],
        xcode_configuration = d["xcode_configuration"],
    )

def _dict_to_run_info(d):
    return struct(
        args = _dicts_to_arg_env_infos(d["args"]),
        build_targets = _dicts_to_build_target_infos(d["build_targets"]),
        diagnostics = _dict_to_diagnostics_info(d["diagnostics"]),
        env = _dict_of_dicts_to_arg_env_infos(d["env"]),
        env_include_default = d["env_include_default"],
        launch_target = _dict_to_launch_target_info(d["launch_target"]),
        xcode_configuration = d["xcode_configuration"],
    )

def _dict_to_test_info(d):
    return struct(
        args = _dicts_to_arg_env_infos(d["args"]),
        build_targets = _dicts_to_build_target_infos(d["build_targets"]),
        diagnostics = _dict_to_diagnostics_info(d["diagnostics"]),
        env = _dict_of_dicts_to_arg_env_infos(d["env"]),
        env_include_default = d["env_include_default"],
        test_targets = _dicts_to_test_target_infos(d["test_targets"]),
        use_run_args_and_env = d["use_run_args_and_env"],
        xcode_configuration = d["xcode_configuration"],
    )

def _dict_to_xcscheme_info(d):
    return struct(
        name = d["name"],
        profile = _dict_to_profile_info(d["profile"]),
        test = _dict_to_test_info(d["test"]),
        run = _dict_to_run_info(d["run"]),
    )

def _dicts_to_build_target_infos(dicts):
    return [
        struct(
            id = d["id"],
            post_actions = _dicts_to_pre_post_action_infos(d["post_actions"]),
            pre_actions = _dicts_to_pre_post_action_infos(d["pre_actions"]),
        )
        for d in dicts
    ]

def _dicts_to_arg_env_infos(dicts):
    return [
        struct(
            enabled = d["enabled"],
            value = d["value"],
        )
        for d in dicts
    ]

def _dicts_to_pre_post_action_infos(dicts):
    return [
        struct(
            for_build = d["for_build"],
            order = d["order"],
            script_text = d["script_text"],
            title = d["title"],
        )
        for d in dicts
    ]

def _dicts_to_test_target_infos(dicts):
    return [
        struct(
            enabled = d["enabled"],
            id = d["id"],
            post_actions = _dicts_to_pre_post_action_infos(d["post_actions"]),
            pre_actions = _dicts_to_pre_post_action_infos(d["pre_actions"]),
        )
        for d in dicts
    ]

# API

def json_to_xcscheme_infos(json_str):
    return [
        _dict_to_xcscheme_info(xcscheme_info_dict)
        for xcscheme_info_dict in json.decode(json_str)
    ]
