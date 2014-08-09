"==============================================================================
" FILE: git_cached.vim
" AUTHOR: Yuku Takahashi <taka84u9 at gmail.com>
" Last Modified: 28 Oct 2012
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
" 
"     The above copyright notice and this permission notice shall be included
"     in  all copies or substantial portions of the Software.
" 
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"==============================================================================

let s:source = {
            \ 'name'        : 'git_cached',
            \ 'hooks'       : {},
            \ }

function! s:source.gather_candidates(args, context)
    let kind = unite_git_util#get_kind()
    let result = unite#util#system('git ls-files')
    if unite#util#get_last_status() == 0
        return has('lua') ?
              \ unite#sources#git_cached#gather_lua(kind, result) :
              \ unite#sources#git_cached#gather_vim(kind, result)
    else
        call unite#util#print_error('Not a Git repository.')
        return []
    endif
endfunction

function! unite#sources#git_cached#gather_vim(kind, result)
    let candidates = []
    let paths = split(a:result, '\r\n\|\r\|\n')
    for path in paths
        let dict = {
                    \ 'word'         : path,
                    \ 'kind'         : a:kind,
                    \ 'action__path' : path,
                    \ }
        call add(candidates, dict)
    endfor
    return candidates
endfunction

function! unite#sources#git_cached#gather_lua(kind, result)
    let candidates = []

    lua << EOF
do
    local candidates = vim.eval('candidates')
    local kind = vim.eval('a:kind')
    local result = vim.eval('a:result')
    for path, sep in string.gmatch(result, "[^\r\n]+") do
        local dict = vim.dict()

        dict.word = path
        dict.kind = kind
        dict.action__path = path

        candidates:add(dict)
    end
end
EOF

    return candidates
endfunction

function! unite#sources#git_cached#define()
    return s:source
endfunction
