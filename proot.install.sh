#!/usr/bin/env bash
set -Eeuo pipefail

# Global Configuration
declare -r USER_PROFILE_DIR='/root/'
declare -r USER_SESSION_SCRIPT="$USER_PROFILE_DIR/.xsession"
declare -r XRDP_START_SCRIPT='/usr/local/bin/xrdp-start'
declare -r SESSION_MANAGER_INI='/etc/xrdp/sesman.ini'
declare -r XRDP_INI='/etc/xrdp/xrdp.ini'
declare -r PAM_INI='/etc/pam.d/xrdp-sesman'
declare -r ROOT_ONLY_WARNING='Only root RDP user supported on android'
declare -r LAST_LOG="$(mktemp)"

export DEBIAN_FRONTEND="noninteractive"

# Error handler triggered automatically by `set -E` on any failure
on_error() {
    cat "$LAST_LOG"
    echo '====================================='
    echo 'Failed to install! See previous error.'
    echo '====================================='
}
trap on_error ERR

update_system() {
    echo 'Get updates'
    apt update > "$LAST_LOG" 2>&1

    echo 'Remove unused packages'
    apt autoremove -y --purge > "$LAST_LOG" 2>&1

    echo 'Upgrade system to the last version'
    apt upgrade -y > "$LAST_LOG" 2>&1

    echo 'Install GNU versions of core utils for compatibility'
    apt install -y gnu-coreutils coreutils-from-gnu coreutils-from-uutils- --allow-remove-essential > "$LAST_LOG" 2>&1

    echo -n '' > "$LAST_LOG"
}

install_packages() {
    echo 'Install xfce'
    apt install -y --no-install-recommends xfce4 xfce4-terminal dbus-x11 > "$LAST_LOG" 2>&1

    echo 'Install xrdp'
    apt install -y --no-install-recommends xrdp xorgxrdp xclip xsel fuse3 ca-certificates > "$LAST_LOG" 2>&1
    
    echo -n '' > "$LAST_LOG"
}

configure_xfce_session() {
    echo 'Creating startup script'
    echo 'startxfce4' > "$USER_SESSION_SCRIPT"
    chmod 600 "$USER_SESSION_SCRIPT"

    echo 'Configure start window manager script'
    sed -i 's|test -x /etc/X11/Xsession && exec /etc/X11/Xsession|exec startxfce4|' /etc/xrdp/startwm.sh
}

configure_xrdp() {
    echo "Allow root RDP login ($ROOT_ONLY_WARNING)"
    sed -i 's/AllowRootLogin=.*/AllowRootLogin=true/g' "$SESSION_MANAGER_INI"

    echo 'Allow RDP extra features'
    sed -i 's/^allow_channels=.*/allow_channels=true/' "$XRDP_INI"

    echo 'Enable clipboard'
    sed -i 's/^#*cliprdr=.*/cliprdr=true/' "$XRDP_INI"

    echo 'Enable drive redirection'
    sed -i 's/^#*rdpdr=.*/rdpdr=true/' "$XRDP_INI"

    echo 'Configure FUSE mount directory for local drive redirection'
    sed -i 's/^#*FuseMountName=.*/FuseMountName=thinclient_drives/' "$SESSION_MANAGER_INI"
    sed -i 's/^#*EnableFuseMount=.*/EnableFuseMount=true/' "$SESSION_MANAGER_INI"
}

configure_pam() {
    echo "Enable root login in PAM module ($ROOT_ONLY_WARNING)"
    cat << 'EOF' > "$PAM_INI"
#%PAM-1.0
auth sufficient pam_permit.so
account sufficient pam_permit.so
session sufficient pam_permit.so
EOF
}

create_start_script() {
    echo 'Creating startup file'
    cat << 'EOF' > "$XRDP_START_SCRIPT"
#!/usr/bin/env sh

pkill xrdp-sesman \
    && echo "Stopping RDP session manager..."

pkill xrdp \
    && echo "Stopping RDP..."

rm -rf /run/xrdp/*
echo 'Starting RDP...'
/usr/sbin/xrdp-sesman && /usr/sbin/xrdp \
    && echo 'RDP server started.' \
    || echo 'Error: failed to start RDP server!'
    
EOF
    chmod +x "$XRDP_START_SCRIPT"
}

print_success() {
    echo ''
    echo '======================'
    echo 'Installation completed.'
    echo ''
    echo 'Run "passwd" to set RDP password.'
    echo '======================'
}

main() {
    # update_system
    # install_packages
    configure_xfce_session
    configure_xrdp
    configure_pam
    create_start_script
    print_success
}

main "$@"
