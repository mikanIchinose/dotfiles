" hook_add {{{
command! DppUpdate call dpp#async_ext_action('installer', 'update')
command! DppCheckNotUpdated call dpp#async_ext_action('installer', 'checkNotUpdated')
" }}}
