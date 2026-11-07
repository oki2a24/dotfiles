# Pi (pi coding agent)

`models.json` は Pi のグローバルモデル設定。`link.sh` によって
`~/.pi/agent/models.json` へシンボリックリンクされる。

## Strata 接続

Pi からは Strata アプリが起動する inference engine
(`http://127.0.0.1:18500/v1`) へ直接接続する。engine は model ID を無視して
「現在 loaded されているモデル」で答えるため、Strata GUI でモデルを切り替えても
`pi --model strata/strata` がそのまま使える。API key は `strata-key.sh` によって
request 時に live instance config から読み取られ、key 自体は repository へ保存しない。

Strata 自身の gateway (`STRATA_PORT`、opencode が使う
`http://127.0.0.1:47831/v1`) へ接続する場合は、model ID が GUI で現在 loaded されている
instance の ID (`curl -s http://127.0.0.1:47831/v1/models` で確認) と一致が必要。
不一致の場合は 400 「Choose a loaded model ID」 となる。
