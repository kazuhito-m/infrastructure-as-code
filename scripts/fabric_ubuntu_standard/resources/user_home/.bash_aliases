# docker alias
alias docker_allrm='docker ps -qa | xargs docker rm -f; docker images -qa | xargs docker rmi -f'

# google drive easy mount
alias gdrive_m='google-drive-ocamlfuse ~/GoogleDrive'
alias gdrive_u='fusermount -u ~/GoogleDrive'
