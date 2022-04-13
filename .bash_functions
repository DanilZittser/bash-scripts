extc () { find "$1" -type f | rev | cut -d "." -f1 | rev | uniq -c | awk '{print $2,$1}'; }

function cd() {
    builtin cd "$@"
    ls
}

function mkenv () {
    python3 -m venv venv
    source venv/bin/activate
    pip3 install --upgrade pip

    if [[ -f requirements.txt ]]; then
        pip3 install -r requirements.txt
    fi
}

function mkproject () {
    mkdir -p "$1"/{assets,jupyter,src}
    builtin cd "$1"
    echo "ipykernel==6.9.2" >> requirements.txt
    mkenv
    python3 -m ipykernel install --prefix "$2" --name "$1" --display-name "$1"
}

function lscp () {
    "ls" "$1" | tr "\n" "$2" | xclip
}

function mkvideo () {
    ffmpeg -framerate 24 -i %05d.jpg ~/"$1".mp4
}

function remkdir () {
    rm -rf "$1" && mkdir "$1"
}

function renumerate () {
    ls -v | awk 'NR>1 { print $9 }' | cat -n | while read n f; do mv -n "$f" $(printf "%05d.jpg" "$n"); done
}
