# 運用テクニックなど
### DBのパスワードについて
- tfstateにDBのパスワードが残ってしまうため、パスワードだけはapply後に手動で変更するのが望ましい。（もしくはアクセス権制御）
- その際、Lifecycleのignore_changesを使うと良い。

### RDSの削除について
- 設定変更
  - deletion_protection = false
  - skip_final_snapshot = true
  - apply_immediately   = true
- terraform apply実行
- aws_db_instanceリソースをコメントアウト
- terraform apply実行

# SSH Key作成
```
$ ssh-keygen -t rsa -b 2048 -f terraform-playground-keypair
```

# tfstate
- S3で管理するのが望ましい

# SSL証明書設定
1. ドメインを取得する
2. route53のホストゾーンがもつ４つのNSレコードをドメインに適用する
3. Certificate ManagerのCNAMEレコードのname, valueをドメインに適用する
4. 実際に証明書を取りに行く