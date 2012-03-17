function! unite#sources#git_cached#define()
    return s:source
endfunction

let s:source = {
            \ 'name'        : 'git_cached',
            \ 'hooks'       : {},
            \ }

function! s:source.gather_candidates(args, context)
    let result = unite#util#system('git ls-files')
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
        call unite#util#print_error('Not a Git repository.')
        return []
    endif
endfunction
