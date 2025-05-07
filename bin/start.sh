#!/usr/bin/env sh

start_mail() {
    echo "Starting Mail..."
    tmux new-session -s mail -d
    tmux send-keys -t mail:0 "mailspring --password-store=\"gnome-libsecret\" " C-m
}

start_previewly() {
    echo "Starting Previewly..."
    PROJECT="previewly"

    # start go backend
    cd ~/work/$PROJECT/$PROJECT-backend/ || {
        echo "Error: Could not change directory to ~/work/$PROJECT/$PROJECT-backend/"
        exit 1
    }
    PROJECT_BACKEND=go-$PROJECT
    tmux new-session -s $PROJECT_BACKEND -d
    tmux send-keys -t $PROJECT_BACKEND:0 "gaper" C-m

    #start angular frontend
    cd ~/work/$PROJECT/$PROJECT-frontend/ || {
        echo "Error: Could not change directory to ~/work/$PROJECT/$PROJECT-frontend/"
        exit 1
    }
    PROJECT_ANGULAR=angular-$PROJECT
    tmux new-session -s $PROJECT_ANGULAR -d
    tmux send-keys -t $PROJECT_ANGULAR:0 "pnpm install && pnpm start" C-m

    #start frontend nvim
    cd ~/work/$PROJECT/$PROJECT-frontend/ || {
        echo "Error: Could not change directory to ~/work/$PROJECT/$PROJECT-frontend/"
        exit 1
    }
    PROJECT_NVIM_FRONTEND=nvim-$PROJECT-frontend
    tmux new-session -s $PROJECT_NVIM_FRONTEND -d

    #start backend nvim
    cd ~/work/$PROJECT/$PROJECT-backend/ || {
        echo "Error: Could not change directory to ~/work/$PROJECT/$PROJECT-backend/"
        exit 1
    }
    PROJECT_NVIM_BACKEND=nvim-$PROJECT-backend
    tmux new-session -s $PROJECT_NVIM_BACKEND -d
}

start_timeline() {
    echo "Starting Timeline..."
    PROJECT="timeline"

    # start go backend
    cd ~/work/$PROJECT/$PROJECT-backend/ || {
        echo "Error: Could not change directory to ~/work/$PROJECT/$PROJECT-backend/"
        exit 1
    }
    PROJECT_BACKEND=go-$PROJECT
    tmux new-session -s $PROJECT_BACKEND -d
    tmux send-keys -t $PROJECT_BACKEND:0 "gaper --program-args=\"-development=true\" " C-m

    #start angular frontend
    cd ~/work/$PROJECT/$PROJECT-frontend/ || {
        echo "Error: Could not change directory to ~/work/$PROJECT/$PROJECT-frontend/"
        exit 1
    }
    PROJECT_ANGULAR=angular-$PROJECT
    tmux new-session -s $PROJECT_ANGULAR -d
    tmux send-keys -t $PROJECT_ANGULAR:0 "pnpm install && pnpm start" C-m

    #start frontend nvim
    cd ~/work/$PROJECT/$PROJECT-frontend/ || {
        echo "Error: Could not change directory to ~/work/$PROJECT/$PROJECT-frontend/"
        exit 1
    }
    PROJECT_NVIM_FRONTEND=nvim-$PROJECT-frontend
    tmux new-session -s $PROJECT_NVIM_FRONTEND -d

    #start backend nvim
    cd ~/work/$PROJECT/$PROJECT-backend/ || {
        echo "Error: Could not change directory to ~/work/$PROJECT/$PROJECT-backend/"
        exit 1
    }
    PROJECT_NVIM_BACKEND=nvim-$PROJECT-backend
    tmux new-session -s $PROJECT_NVIM_BACKEND -d
}

start_obsidian() {
    echo "Starting Obsidian..."
    cd ~/Documents/obsidian/ || {
        echo "Error: Could not change directory to ~/Documents/obsidian/"
        exit 1
    }
    tmux new-session -s obsidian -d
}

case "$1" in
mail)
    start_mail
    ;;
previewly)
    start_previewly
    ;;
timeline)
    start_timeline
    ;;
obsidian)
    start_obsidian
    ;;
*)
    echo "Usage: $0 {mail|previewly|timeline|obsidian}"
    exit 1
    ;;
esac

exit 0
