#!/usr/bin/env sh

CONTAINER_BACKUP_FOLDER="/home/wert2all/work/gitlab/gitlab/backup/"
BACKUP_FOLDER="/mnt/nas1/backup/gitlab/"

datePrefix=$(date +%Y-%m-%d)
fileName="gitlab-${datePrefix}"
userId=$(id -u)
groupId=$(id -g)

echo "Create a backup file ${fileName}"
docker exec -t gitlab sh -c "COMPRESS_CMD=\"gzip -c --best\" gitlab-backup create SKIP=db,uploads,builds,artifacts,pages,lfs,terraform_state,registry,packages,external_diffs BACKUP=\"${fileName}\""
docker exec -t gitlab sh -c "mv /var/opt/gitlab/backups/${fileName}* /backup/"
sudo mv ${CONTAINER_BACKUP_FOLDER}/* ${BACKUP_FOLDER}
sudo chown ${userId}:${groupId} ${BACKUP_FOLDER}/*
# docker exec -t gitlab sh -c "chown ${userId}:${groupId} /var/opt/gitlab/backups/${fileName}*"
