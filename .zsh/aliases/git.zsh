# Git aliases
alias gfa='git fetch --all --tags --prune --jobs=10'
alias gss='git status --short'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gl='git log --graph --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'

alias gcb='git checkout -b'
alias gcr="gitCheckoutAndReset"
alias gr="git reset --hard"
alias grm="git reset --hard origin/main"

alias gra="git rebase --abort"
alias grc="git rebase --continue"

alias gaa="git add --all"
alias gau="git add -u && gss"

alias gum="git pull origin main --rebase"
alias gph="git push origin HEAD"

alias gcn='git commit --verbose --no-edit'
alias gcn!='git commit --verbose --no-edit --amend'
alias gca='git commit --verbose --amend'

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

alias gcl='git clone --recurse-submodules'
alias gwt="gitWorktree"
alias gwtrall="gwtremoveall"
