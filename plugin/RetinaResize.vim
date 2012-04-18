"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/RetinaResize.vim
"VERSION:  0.9
"LICENSE:  MIT

if exists("g:loaded_RetinaResize")
    finish
endif
let g:loaded_RetinaResize = 1

let s:save_cpo = &cpo
set cpo&vim

command! -range RetinaResize <line1>,<line2>call retinaresize#RetinaResize()

let &cpo = s:save_cpo
