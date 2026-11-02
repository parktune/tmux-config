#!/bin/sh

# 함수 전체를 읽은 후 실행하므로 curl | sh로도 사용할 수 있습니다.
main() {
    set -eu

    install_packages() {
        if command -v apt-get >/dev/null 2>&1; then
            if [ "$(id -u)" -eq 0 ]; then
                apt-get update
                apt-get install -y "$@"
            else
                sudo apt-get update
                sudo apt-get install -y "$@"
            fi
        elif command -v brew >/dev/null 2>&1; then
            brew install "$@"
        elif command -v dnf >/dev/null 2>&1; then
            if [ "$(id -u)" -eq 0 ]; then
                dnf install -y "$@"
            else
                sudo dnf install -y "$@"
            fi
        elif command -v pacman >/dev/null 2>&1; then
            if [ "$(id -u)" -eq 0 ]; then
                pacman -S --needed --noconfirm "$@"
            else
                sudo pacman -S --needed --noconfirm "$@"
            fi
        else
            printf '%s\n' "패키지 관리자를 찾지 못했습니다. 먼저 설치하세요: $*" >&2
            exit 1
        fi
    }

    # 이미 있는 tmux와 Git은 업데이트하거나 재설치하지 않습니다.
    set --
    if ! command -v tmux >/dev/null 2>&1; then
        set -- "$@" tmux
    fi
    if ! command -v git >/dev/null 2>&1; then
        set -- "$@" git
    fi
    if [ "$#" -gt 0 ]; then
        install_packages "$@"
    fi

    workspace=$(mktemp -d "${TMPDIR:-/tmp}/tmux-config.XXXXXX")
    trap 'rm -rf -- "$workspace"' 0
    trap 'exit 1' HUP INT TERM
    git clone --depth 1 https://github.com/parktune/tmux-config.git "$workspace/repo"
    sh "$workspace/repo/install.sh"
    rm -rf -- "$workspace"
    trap - 0 HUP INT TERM
    printf '%s\n' '완료: tmux 설정을 적용하고 임시 Git 저장소를 삭제했습니다.'
}

main "$@"
