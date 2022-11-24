extc () { find "$1" -type f | rev | cut -d "." -f1 | rev | uniq -c | awk '{print $2,$1}'; }

function cd() {
    builtin cd "$@"
    ls
}

function mkenv () {
    python3 -m venv venv
    source venv/bin/activate
    pip3 install --upgrade pip

    if [[ -f requirements-dev.txt ]]; then
        pip3 install -r requirements-dev.txt
    elif [[ -f requirements.txt ]]; then
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
    ffmpeg -framerate 24 -pattern_type glob -i '*.jpg' ~/"$1".mp4
}

function remkdir () {
    rm -rf "$1" && mkdir "$1"
}

function renumerate () {
    ls -v | awk 'NR>1 { print $9 }' | cat -n | while read n f; do mv -n "$f" $(printf "%05d.jpg" "$n"); done
}

function install-jupyter () {
    # make environment
    sudo mkdir -p /opt/jupyter
    sudo chown -R $USER:$USER /opt/jupyter
    builtin cd /opt/jupyter
    echo -e "notebook==6.4.11\njupyter-contrib-nbextensions==0.5.1" >> requirements.txt
    python3 -m venv venv
    source venv/bin/activate
    pip3 install --upgrade pip
    pip3 install -r requirements.txt
    jupyter contrib nbextension install --user

    # prepare jupyter-launcher script
    echo "#!/bin/bash
source /opt/jupyter/venv/bin/activate
cd ~
jupyter notebook" >> jupyter-launcher.sh
    chmod +x jupyter-launcher.sh
}
