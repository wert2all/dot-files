#!/usr/bin/env sh

# start go backend
cd ~/work/timeline/timeline-backend/ || exit
tmux new-session -s 'go-timeline' -d
tmux send-keys -t go-timeline:0 "docker compose up -d" C-m
tmux send-keys -t go-timeline:0 "gaper --program-args=\"-postgres-port=5434\"" C-m

#start angular frontend
cd ~/work/timeline/timeline-frontend/ || exit
tmux new-session -s 'angular-timeline' -d
tmux send-keys -t angular-timeline:0 "pnpm install && pnpm start" C-m

#start frontend nvim
cd ~/work/timeline/timeline-frontend/ || exit
tmux new-session -s 'nvim-timeline-frontend' -d
tmux send-keys -t nvim-timeline-frontend:0 "nvim" C-m

#start backend nvim
cd ~/work/timeline/timeline-backend/ || exit
tmux new-session -s 'nvim-timeline-backend' -d
tmux send-keys -t nvim-timeline-backend:0 "nvim" C-m
