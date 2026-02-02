# clipbord copy (macos inspire)
alias pbcopy='xsel --clipboard --input'

# docker alias
alias docker_allrm='docker ps -qa | xargs docker rm -f; docker images -qa | xargs docker rmi -f'

# google drive easy mount
alias gdrive_m='google-drive-ocamlfuse ~/GoogleDrive'
alias gdrive_u='fusermount -u ~/GoogleDrive'

# work script
## manga
alias manga_fix=~/Dropbox/scripts/manga_work/manga_fix.sh
alias fix_image_file_name=~/Dropbox/scripts/manga_work/fix_image_file_name.sh
alias remove_same_dir=~/Dropbox/scripts/manga_work/remove_same_dir.sh
alias conv_zen_to_han_filename=~/Dropbox/scripts/manga_work/conv_zen_to_han_filename.sh

## youtube download
alias yt_dl_playlist=~/Dropbox/scripts/youtube/yt_dl_playlist.sh
alias yt_dl=~/Dropbox/scripts/youtube/yt_dl.sh

## develop
alias gnrb=~/Dropbox/scripts/git_new_remote_branch.sh

## WoL
alias wol_fumiko='wakeonlan 00:24:21:1e:5a:0e'

## common
alias replace_all_file_content_by_regex=~/Dropbox/scripts/replace_all_file_content_by_regex.sh

