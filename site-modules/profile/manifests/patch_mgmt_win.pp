# patch_mgmt_win
class profile::patch_mgmt_win (
) {
  include os_patching

  include patching_as_code
}
