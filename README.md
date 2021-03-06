# CodePipeline構築方法
- terraform.tfvars.sampleをterraform.tfvarsに変更
  - aws_access_key/aws_secret_key/github_tokenを各自の環境の値に変更
- S3バケット名の変更
  - S3バケットを固有の名前に変更
- terraform apply実行
  - `$ terraform apply`
  - apply完了後にoutputされている値はメモする
- AWSコンソールからビルド完了確認
- service.json編集
  - apply完了時にoutputされているARNをservice.json
- ECSサービス作成
  - `$ aws ecs create-service --cli-input-json file://service.json --region=ap-northeast-1`
- codedeploy.tf/codepipeline.tfファイルのコメントアウトを外す
- terraform apply実行
  - `$ terraform apply`
  
# ご参考
- https://dev.classmethod.jp/articles/ecs-deploy-with-codepipeline/