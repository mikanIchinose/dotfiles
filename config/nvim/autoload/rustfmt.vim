" rustfmtのコマンドをvimscript/luaから呼び出せるようにするためのインターフェース
" 基本は:RustFmtというコマンド向け

let s:got_fmt_error = 0

function! s:DeleteLines(start, end) abort
    silent! execute a:start . ',' . a:end . 'delete _'
endfunction

function! s:RustfmtCommand()
    return 'rustfmt --emit=stdout --edition=2018'
    " return join(['rustfmt', '--emit=stdout', '--edition=2018'])
endfunction

function! s:RunRustfmt(command, from_writepre)
    let l:view = winsaveview()

    let l:stderr_tmpname = tempname()
    call writefile([], l:stderr_tmpname)

    let l:command = a:command . ' 2> ' . l:stderr_tmpname " rustfmt --emit=stdout --edition=2018 2> '$tmpfile'

    " Rustfmt in stdin/stdout mode
    " chdir to the directory of the file
    let l:has_lcd = haslocaldir()
    let l:prev_cd = getcwd()
    execute 'lchdir! '.expand('%:h')

    let l:buffer = getline(1, '$')
    if exists("*systemlist")
        silent let out = systemlist(l:command, l:buffer)
    else
        silent let out = split(system(l:command,
                    \ join(l:buffer, "\n")), '\r\?\n')
    endif

    let l:stderr = readfile(l:stderr_tmpname)

    call delete(l:stderr_tmpname)

    let l:open_lwindow = 0
    if v:shell_error == 0
        if a:from_writepre
            " remove undo point caused via BufWritePre
            try | silent undojoin | catch | endtry
        endif

        let l:content = l:out

        call s:DeleteLines(len(l:content), line('$'))
        call setline(1, l:content)

        " only clear location list if it was previously filled to prevent
        " clobbering other additions
        if s:got_fmt_error
            let s:got_fmt_error = 0
            call setloclist(0, [])
            let l:open_lwindow = 1
        endif
    else
        " otherwise get the errors and put them in the location list
        let l:errors = []

        let l:prev_line = ""
        for l:line in l:stderr
            " error: expected one of `;` or `as`, found `extern`
            "  --> src/main.rs:2:1
            let tokens = matchlist(l:line, '^\s\+-->\s\(.\{-}\):\(\d\+\):\(\d\+\)$')
            if !empty(tokens)
                call add(l:errors, {"filename": @%,
                            \"lnum":	tokens[2],
                            \"col":	tokens[3],
                            \"text":	l:prev_line})
            endif
            let l:prev_line = l:line
        endfor

        if !empty(l:errors)
            call setloclist(0, l:errors, 'r')
            echohl Error | echomsg "rustfmt returned error" | echohl None
        else
            echo "nvim_next: was not able to parse rustfmt messages. Here is the raw output:"
            echo "\n"
            for l:line in l:stderr
                echo l:line
            endfor
        endif

        let s:got_fmt_error = 1
        let l:open_lwindow = 1
    endif

    " Restore the current directory if needed
    if l:has_lcd
        execute 'lchdir! '.l:prev_cd
    else
        execute 'chdir! '.l:prev_cd
    endif

    " Open lwindow after we have changed back to the previous directory
    if l:open_lwindow == 1
        lwindow
    endif

    call winrestview(l:view)
endfunction

" 今開いているファイルに対してrustfmtを実行する
function! rustfmt#Format()
  call s:RunRustfmt(s:RustfmtCommand(), v:false)
endfunction
