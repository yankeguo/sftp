#!/bin/sh

SSHD_ROOT_PASSWORD="${SSHD_ROOT_PASSWORD:-}"
SSHD_ROOT_AUTHORIZED_KEYS="${SSHD_ROOT_AUTHORIZED_KEYS:-}"

set -eu

if [ -n "${SSHD_ROOT_PASSWORD}" ]; then
    PASSWD="root:${SSHD_ROOT_PASSWORD}" printenv PASSWD | chpasswd
else
    passwd -l
fi

if [ -n "${SSHD_ROOT_AUTHORIZED_KEYS}" ]; then
    mkdir -p "/root/.ssh"
    echo "${SSHD_ROOT_AUTHORIZED_KEYS}" >>"/root/.ssh/authorized_keys"
    chmod 600 "/root/.ssh/authorized_keys"
fi

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    ssh-keygen -t rsa -b 4096 -f "/etc/ssh/ssh_host_rsa_key" -N ''
    chmod 600 "/etc/ssh/ssh_host_rsa_key"
fi

if [ ! -f "/etc/ssh/ssh_host_ed25519_key" ]; then
    ssh-keygen -t ed25519 -f "/etc/ssh/ssh_host_ed25519_key" -N ''
    chmod 600 "/etc/ssh/ssh_host_ed25519_key"
fi

exec /sbin/tini -- "$@"
