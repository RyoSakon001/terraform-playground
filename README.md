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