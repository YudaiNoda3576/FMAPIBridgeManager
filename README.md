# FileMaker API Bridge Manager
FileMaker API に接続するためのアプリケーション

# 起動方法
1. ルートディレクトリに`.env`を設置してください。
  ```
  FILEMAKER_HOST_SAFTA=
FILEMAKER_DB_SAFTA=
CLARIS_ID=
CLARIS_PASS=
BASIC_USER=admin
BASIC_PASS=
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_URL=redis://redis:6379
```
3. ルートディレクトリで`$ docker-compose up`を実行してください。

`localhost:8000`

# 備考
* FMとのマッピングはfmrest-ruby gemを使用しています。
  * https://github.com/beezwax/fmrest-ruby
