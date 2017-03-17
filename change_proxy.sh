#!/bin/zsh

function get_password() {
    cat .secret | grep PASSWORD | sed -e "s/PASSWORD=\(.*\)/\1/"
}

function get_proxy_mode() {
    dconf read /system/proxy/mode | sed -e "s/'//g"
}

function get_http_proxy() {
    HOST=$(dconf read /system/proxy/http/host | sed -e "s/'//g")
    PORT=$(dconf read /system/proxy/http/port)
    echo $HOST:$PORT
}

function get_https_proxy() {
    HOST=$(dconf read /system/proxy/https/host | sed -e "s/'//g")
    PORT=$(dconf read /system/proxy/https/port)
    echo $HOST:$PORT
}

function enable_npm_proxy() {
    echo $(get_http_proxy)
    echo $(get_https_proxy)
    expect -c "
    spawn sh -c \"sudo -k -p password: npm -g config set proxy http://$(get_http_proxy)\"
    expect password:
    send \"$PASSWORD\n\"
    interact
    "
    expect -c "
    spawn sh -c \"sudo -k -p password: npm -g config set https-proxy http://$(get_https_proxy)\"
    expect password:
    send \"$PASSWORD\n\"
    interact
    "
}

function disable_npm_proxy() {
    echo $(get_http_proxy)
    echo $(get_https_proxy)
    expect -c "
    spawn sh -c \"sudo -k -p password: npm -g config rm proxy\"
    expect password:
    send \"$PASSWORD\n\"
    interact
    "
    expect -c "
    spawn sh -c \"sudo -k -p password: npm -g config rm https-proxy\"
    expect password:
    send \"$PASSWORD\n\"
    interact
    "
}

function enable_git_proxy() {
    echo $(get_http_proxy)
    echo $(get_https_proxy)
    git config --global http.proxy http://$(get_http_proxy)
    git config --global https.proxy http://$(get_http_proxy)
}

function disable_git_proxy() {
    echo $(get_http_proxy)
    echo $(get_https_proxy)
    git config --global --unset http.proxy
    git config --global --unset https.proxy
}

PASSWORD=$(get_password)
echo $(get_password)

while; do
    echo $(get_proxy_mode)
    if [ $(get_proxy_mode) = manual ]; then
        enable_npm_proxy
    else
        disable_npm_proxy
    fi
    npm -g config list
    sleep 1m
done
