# Description

This repo configures a Status CMS using [Webiny](https://www.webiny.com/) hosted at https://get.status.im/.

# Configuration

To start working you'll need to configure `awscli`:
```sh
 $ aws configure
AWS Access Key ID [None]: <ACCESS_KEY>
AWS Secret Access Key [None]: <SECRET_KEY>
Default region name [None]: eu-central-1
Default output format [None]:
```
And create an `.env.json` file based off of [`example.env.json`](/example.env.json)
You will need to provide a valid value for `MONGODB_SERVER` which should take the form of a [Mongo URI](https://docs.mongodb.com/manual/reference/connection-string/).
The `default` value for `AWS_PROFILE` is fine most of the time unless you used the `--profile` flag.

For more details see the [official documentation](https://docs.webiny.com/docs/get-started/quick-start/).

# Deployment

To deploy a `dev` environment use:
```
yarn run webiny deploy-api --env=prod
yarn run webiny deploy-apps --env=prod
```
You can do the same for the `prod` env.

# Infrastructure

The infra for this service is managed in the [`infra-webiny`](https://github.com/status-im/infra-webiny) repository.
