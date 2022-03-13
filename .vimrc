noremap ; l
noremap l k
noremap k j
noremap j h

set scrolloff=5

set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
augroup END
