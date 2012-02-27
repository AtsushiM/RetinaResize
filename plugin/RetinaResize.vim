"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/RetinaResize.vim
"VERSION:  0.9
"LICENSE:  MIT

function! s:_checkDigit(num)
    let line = matchlist(string(a:num), '\v(.*)\.(.*)')

    if line[2] == 0
        let ret = line[1]
    else
        let ret = string(a:num)
    endif

    echo ret

    return str2nr(ret)
endfunction

function! s:_RetinaResizeCSS()
    let line = matchlist(getline('.'), '\v(.*)(: *)(-*[^;]*)(;*)')
    if line != []
        let ret = ''
        let value = line[3]
        let end = 0

        while end != 1
            let match = matchlist(value, '\v([^0-9]*)([0-9]*)(.*)')

            if match[2] != ''
                let num = <SID>_checkDigit(match[2] / 2.0)
                let ret = ret.match[1].string(num)
                let value = match[3]
            else
                let ret = ret.value
                let end = 1
            endif
        endwhile

        if value != ret
            let reg_save = @@
            let @@ = line[1].line[2].ret.line[4]

            silent normal ^i/* 
            silent normal $a */
            silent normal o
            silent normal p

            let @@ = reg_save
            return 1
        else
            return 0
        endif
    else
        return 0
    endif
endfunction
function! s:_RetinaResizeHTML()
    let line = matchlist(getline('.'), '\v(.*\<img )([^\>]*)(\>.*)')
    if line != []
        let ret = ''
        let value = line[2]
        let end = 0

        while end != 1
            let match = matchlist(value, '\v(.{-})(width|height)(\=")([0-9]*)(.{-}")(.*)')

            if match != []
                let num = <SID>_checkDigit(match[4] / 2.0)
                let ret = ret.match[1].match[2].match[3].string(num).match[5]
                let value = match[6]
            else
                let ret = ret.value
                let  end = 1
            endif
        endwhile

        if value != ret
            let reg_save = @@
            let @@ = line[1].ret.line[3]

            silent normal ^i<!-- 
            silent normal $a -->
            silent normal o
            silent normal p

            let @@ = reg_save
            return 1
        else
            return 0
        endif
    else
        return 0
    endif
endfunction
function! s:RetinaResize()
    let res = <SID>_RetinaResizeCSS()
    if res != 1
        let res = <SID>_RetinaResizeHTML()
    endif
endfunction
command! RetinaResize call s:RetinaResize()
