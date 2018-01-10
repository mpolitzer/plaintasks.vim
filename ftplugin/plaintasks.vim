"Vim filetype plugin
" Language: PlainTasks
" Maintainer: David Elentok
" ArchiveTasks() added by Nik van der Ploeg

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

nnoremap <silent> <buffer> +     :call NewTask()<cr>A
vnoremap <silent> <buffer> +     :call NewTask()<cr>
noremap  <silent> <buffer> =     :call ToggleComplete()<cr>
noremap  <silent> <buffer> <C-M> :call ToggleCancel()<cr>
noremap  <silent> <buffer> *     :call ToggleBlocked()<cr>
nnoremap <silent> <buffer> -     :call ArchiveTasks()<cr>
abbr ssep <c-r>=Sseparator()<cr>
abbr lsep <c-r>=Lseparator()<cr>

" when pressing enter within a task it creates another task
setlocal comments+=n:☐

function! ToggleComplete()
  let line = getline('.')
  if line =~ "^ *✔"
    s/^\( *\)✔/\1☐/
    s/ *@done.*$//
  elseif line =~ "^ *☐"
    s/^\( *\)☐/\1✔/
    let text = " @done (" . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal A" . printf("%*s", 82-strlen(line), text)
    normal _
  endif
endfunc

function! ToggleBlocked()
  let line = getline('.')
  if line =~ "^ *⚠"
    s/^\( *\)⚠/\1☐/
    s/ *@blocked.*$//
  elseif line =~ "^ *☐"
    s/^\( *\)☐/\1⚠/
    let text = " @blocked (" . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal A" . printf("%*s", 82-strlen(line), text)
    normal _
  endif
endfunc

function! ToggleCancel()
  let line = getline('.')
  if line =~ "^ *✘"
    s/^\( *\)✘/\1☐/
    s/ *@cancelled.*$//
  elseif line =~ "^ *☐"
    s/^\( *\)☐/\1✘/
    let text = " @cancelled (" . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal A" . printf("%*s", 82-strlen(line), text)
    normal _
  endif
endfunc

function! NewTask()
  let line=getline('.')
  if line =~ "^ *$"
    normal A  ☐ - 
  else
    normal I  ☐ - 
  end
endfunc

function! ArchiveTasks()
    let orig_line=line('.')
    let orig_col=col('.')
    let archive_start = search("^+ archive:")
    if (archive_start == 0)
        call cursor(line('$'), 1)
        normal 2o
        normal i+ archive:
        normal o================================================================================
        let archive_start = line('$') - 1
    endif
    call cursor(1,1)

    let found=0
    let a_reg = @a
    if search("✔", "", archive_start) != 0
        call cursor(1,1)
        while search("✔", "", archive_start) > 0
            if (found == 0)
                normal "add
            else
                normal "Add
            endif
            let found = found + 1
            call cursor(1,1)
        endwhile

        call cursor(archive_start + 1,1)
        normal "ap
    endif

    "clean up
    let @a = a_reg
    call cursor(orig_line, orig_col)
endfunc

function! Sseparator()
	return "--------------------------------------------------------------------------------"
endfunc

function! Lseparator()
	return "================================================================================"
endfunc
