# tmux-config

새 PC에서도 같은 tmux 마우스 설정을 적용하기 위한 개인 설정 저장소입니다.
Ubuntu/Linux, macOS, WSL에서 사용합니다. 플러그인은 필요 없습니다.

## 설정

현재 PC에서 쓰던 설정을 그대로 제공합니다.

```tmux
set -g mouse on
```

- pane을 마우스로 클릭해서 이동
- 마우스 휠로 스크롤
- pane 경계를 드래그해서 크기 조절

기본 prefix(`Ctrl+b`), 색상, 복사 키, 스크롤 기록 크기는 tmux 기본값을 사용합니다.
마우스 이벤트를 지원하는 터미널에서 사용하세요. Vim·less 같은 프로그램에서는
프로그램 자체가 휠 입력을 처리할 수 있습니다. tmux 스크롤 모드에서 나갈 때는 `q`를 누릅니다.

## 새 PC에서 설치

먼저 Git과 tmux를 설치합니다. WSL에서는 Windows PowerShell이 아닌 WSL 셸에서 실행하세요.

Ubuntu/Debian/WSL:

```sh
sudo apt update
sudo apt install -y git tmux
```

macOS(Homebrew가 설치된 환경):

```sh
brew install git tmux
```

다른 Linux 배포판은 해당 패키지 관리자로 Git과 tmux를 설치합니다. 그다음:

```sh
git clone https://github.com/parktune/tmux-config.git
cd tmux-config
sh install.sh
```

설치 스크립트는 `~/.tmux.conf`를 이 저장소의 설정으로 교체합니다.
기존 파일이 다르면 `~/.tmux.conf.backup.XXXXXX` 형태로 먼저 백업합니다.
기존 경로가 심볼릭 링크이면 링크 대상은 보존하고 링크 자리에 설정 파일을 설치합니다.
동일한 설정으로 다시 실행하면 백업을 추가로 만들지 않습니다.
실행 중인 현재/기본 tmux 서버가 있으면 설정을 즉시 다시 읽습니다.
별도 소켓(`tmux -L` 또는 `-S`)의 다른 서버는 그 서버 안에서 직접 적용하세요.

이미 받은 저장소를 업데이트하려면:

```sh
cd tmux-config
git pull --ff-only
sh install.sh
```

이 스크립트는 tmux 패키지 자체를 자동 설치하지 않습니다.

## AI에게 설치 요청

새 PC에서 다음과 같이 요청하면 됩니다.

> https://github.com/parktune/tmux-config 를 읽고 README대로 내 tmux 설정을 적용해줘.
> 기존 설정은 백업하고, 마우스 클릭 pane 이동과 휠 스크롤이 켜졌는지 확인해줘.

## 확인과 복원

tmux를 시작한 뒤 확인합니다.

```sh
tmux show-options -g mouse
# mouse on
```

`Ctrl+b` 다음 `%`로 pane을 나눈 뒤 다른 pane을 클릭해 보세요.
출력이 충분히 쌓인 pane에서 휠을 위로 돌려 이전 출력을 확인하세요.
설치 이전에 만들어진 pane에는 스크롤 기록이 충분하지 않을 수 있습니다.

설치 전 상태로 복원하려면 설치 출력에 나온 실제 백업 파일을 선택합니다.

```sh
cp ~/.tmux.conf.backup.실제접미사 ~/.tmux.conf
```

백업 파일 내용과 함께 실행 중 서버의 마우스 설정도 즉시 되돌리려면:

```sh
tmux set-option -g mouse off
tmux source-file ~/.tmux.conf
```

백업에 `mouse on`이 있으면 다시 켜집니다. 설정 파일에 옵션이 없더라도
이미 실행 중인 서버의 값은 자동 초기화되지 않아 위 순서로 적용합니다.

확정한 범위는 [요구사항 문서](requirements/tmux-config.md)에 기록했습니다.
