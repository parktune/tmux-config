#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config="$HOME/.tmux.conf"

if ! command -v tmux >/dev/null 2>&1; then
    printf '%s\n' 'tmux가 필요합니다. README의 운영체제별 설치 명령을 먼저 실행하세요.' >&2
    exit 1
fi

if [ -L "$config" ] && [ ! -e "$config" ]; then
    printf '%s\n' "끊어진 심볼릭 링크를 먼저 확인하세요: $config" >&2
    exit 1
fi
if [ -e "$config" ] && [ ! -f "$config" ]; then
    printf '%s\n' "일반 파일이 아닙니다: $config" >&2
    exit 1
fi

if [ -f "$config" ] && cmp -s "$script_dir/tmux.conf" "$config"; then
    printf '%s\n' "이미 같은 설정입니다: $config"
else
    if [ -f "$config" ]; then
        backup=$(mktemp "$HOME/.tmux.conf.backup.XXXXXX")
        cp -p "$config" "$backup"
        printf '%s\n' "기존 설정 백업: $backup"
    fi
    temporary=$(mktemp "$HOME/.tmux.conf.tmp.XXXXXX")
    trap 'rm -f "$temporary"' 0
    trap 'exit 1' HUP INT TERM
    cp "$script_dir/tmux.conf" "$temporary"
    mv -f "$temporary" "$config"
    printf '%s\n' "설치 완료: $config"
fi

# 현재 터미널이 연결된 서버, 또는 기본 서버가 있으면 즉시 적용합니다.
if tmux list-sessions >/dev/null 2>&1; then
    tmux source-file "$config"
    printf '%s\n' '실행 중인 tmux 서버에 적용했습니다.'
else
    printf '%s\n' '다음에 tmux를 시작할 때 적용됩니다.'
fi
