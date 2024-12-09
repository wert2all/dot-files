#!/usr/bin/env sh
PROJECT="previewly"

# start go backend
cd ~/work/$PROJECT/$PROJECT-backend/ || exit
PROJECT_BACKEND=go-$PROJECT
tmux new-session -s $PROJECT_BACKEND -d
tmux send-keys -t $PROJECT_BACKEND:0 "docker compose up -d" C-m
tmux send-keys -t $PROJECT_BACKEND:0 "gaper --program-args=\"-postgres-port=5434\"" C-m

#start angular frontend
cd ~/work/$PROJECT/$PROJECT-frontend/ || exit
PROJECT_ANGULAR=angular-$PROJECT
tmux new-session -s $PROJECT_ANGULAR -d
tmux send-keys -t $PROJECT_ANGULAR:0 "pnpm install && pnpm start" C-m

#start frontend nvim
cd ~/work/$PROJECT/$PROJECT-frontend/ || exit
PROJECT_NVIM_FRONTEND=nvim-$PROJECT-frontend
tmux new-session -s $PROJECT_NVIM_FRONTEND -d
tmux send-keys -t $PROJECT_NVIM_FRONTEND:0 "nvim" C-m

#start backend nvim
cd ~/work/$PROJECT/$PROJECT-backend/ || exit
PROJECT_NVIM_BACKEND=nvim-$PROJECT-backend
tmux new-session -s $PROJECT_NVIM_BACKEND -d
tmux send-keys -t $PROJECT_NVIM_BACKEND:0 "nvim" C-m
