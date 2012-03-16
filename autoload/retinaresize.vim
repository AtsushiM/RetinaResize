"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/RetinaResize.vim
"VERSION:  0.9
"LICENSE:  MIT

function! retinaresize#checkDigit(num)
    let line = matchlist(string(a:num), '\v(.*)\.(.*)')

    if line[2] == '0'
        let ret = str2nr(line[1])
    else
        let ret = str2float(string(a:num))
    endif

    return ret
endfunction

function! retinaresize#RetinaResizeCSS()
    let line = matchlist(getline('.'), '\v(.*)(: *)(-*[^;]*)(;*)')
    if line != []
        let ret = ''
        let value = line[3]
        let end = 0

        while end != 1
            let match = matchlist(value, '\v([^0-9]*)([0-9]*\.?[0-9]*)(.*)')

            if match[2] != ''
                let num = retinaresize#checkDigit(str2float(match[2]) / g:RetinaResize_Division)
                let ret = ret.match[1].string(num)
                let value = match[3]
            else
                let ret = ret.value
                let end = 1
            endif
        endwhile

        if value != ret
            if g:RetinaResize_Comment == 1
                silent normal ^i/* 
                silent normal $a */
                silent normal o
            endif
            call setline('.', line[1].line[2].ret.line[4])
            return 1
        else
            return 0
        endif
    else
        return 0
    endif
endfunction
function! retinaresize#RetinaResizeHTML()
    let base = getline('.')
    let org = base
    let baseend = 0
    let baseret = ''

    while baseend == 0
        let line = matchlist(base, '\v(.{-}\<img )([^\>]{-})(\>)(.*)')
        if line != []
            let value = line[2]
            let end = 0
            let ret = ''

            while end != 1
                let match = matchlist(value, '\v(.{-})(width|height)(\=")([0-9]*)(.{-}")(.*)')

                if match != []
                    let num = retinaresize#checkDigit(str2float(match[4]) / g:RetinaResize_Division)
                    let ret = ret.match[1].match[2].match[3].string(num).match[5]
                    let value = match[6]
                else
                    let ret = ret.value
                    let end = 1
                endif
            endwhile

            let ret = line[1].ret.line[3]
            let baseret = baseret.ret
            let base = line[4]
        else
            let baseret = baseret.base
            let baseend = 1
        endif
    endwhile

    echo org

    if org != baseret
        if g:RetinaResize_Comment == 1
            silent normal ^i<!-- 
            silent normal $a -->
            silent normal o
        endif

        call setline('.', baseret)
    endif
endfunction
function! retinaresize#RetinaResize()
    let res = retinaresize#RetinaResizeCSS()
    if res != 1
        let res = retinaresize#RetinaResizeHTML()
    endif
endfunction
