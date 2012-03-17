function! unite#sources#git_untracked#define()
    return s:source
endfunction

let s:source = {
            \ 'name'  : 'git_untracked',
            \ 'hooks' : {},
            \ }

function! s:source.gather_candidates(args, context)
    let result = unite#util#system('git ls-files --others --exclude-standard')
    if unite#util#get_last_status() == 0
        let paths = split(result, '\r\n\|\r\|\n')
        let candidates = []
        for path in paths
            let dict = {
                        \ 'word'         : path,
                        \ 'kind'         : 'jump_list',
                        \ 'action__path' : path,
                        \ }
            call add(candidates, dict)
        endfor
        return candidates
    else
        call unite#util#print_error('Not in a Git repository.')
        return []
    endif
endfunction

