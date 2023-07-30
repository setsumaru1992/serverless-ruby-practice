# イメージ作成
```
# 作成
docker build -t hello-lambda .

# 動作確認
docker run -p 9000:8080 --rm hello-lambda
## 上記でLambdaのリクエスト待ちになるので、下記でリクエストを投げる
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'

## コンテナ内に入るためには以下を実行
docker run -p 9000:8080 -it --rm --entrypoint "bash" hello-lambda
```

# イメージアップロード
```
./upload_to_ecr_with_arn_info.sh
```
