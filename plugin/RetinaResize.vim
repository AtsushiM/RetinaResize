"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/RetinaResize.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:RetinaResize_Comment")
    let g:RetinaResize_Comment = 1
endif
if !exists("g:RetinaResize_Division")
    let g:RetinaResize_Division = 2.0000
endif

command! RetinaResize call retinaresize#RetinaResize()
