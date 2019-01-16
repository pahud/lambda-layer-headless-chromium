# lambda-layer-headless-chromium
AWS Lambda Layer for [headless chromium](https://chromium.googlesource.com/chromium/src/+/lkgr/headless/README.md) with [Noto](https://www.google.com/get/noto/) CJK TC font support.

# build the layer zip
```
$ make build
```
**this will create `layer.zip` in your current directory**


# edit Makefile


| Name                 | Description                                                  | required to update |
| -------------------- | ------------------------------------------------------------ | ------------------ |
| **LAYER_NAME**       | Layer Name                                                   |                    |
| **LAYER_DESC**       | Layer Description                                            |                    |
| **S3BUCKET**         | Your S3 bucket to store the intermediate Lambda bundle zip.<br />Make sure the S3 bucket in the same region with your Lambda function to deploy. | YES                |
| **LAMBDA_REGION**    | The region code to deploy your Lambda function               |                    |
| **LAMBDA_FUNC_NAME** | Lambda function name                                         |                    |
| **LAMBDA_FUNC_DESC** | Lambda function description                                  |                    |
| **LAMBDA_ROLE_ARN**  | Lambda IAM role ARN                                          | YES                |


# upload and publish your layer
```
$ make layer-upload layer-publish
```

# create your main handler
edit `main.sh` or check sampe [here](main.sh)

# create your lambda function bundle with the layer

```
LAMBDA_LAYERS="AWS_CLI_LAYER_ARN YOUR_LAMBDA_LAYER_ARN" make ceate-func
```
e.g.
```
LAMBDA_LAYERS="arn:aws:lambda:ap-northeast-1:903779448426:layer:awscli-layer:15 \
arn:aws:lambda:ap-northeast-1:903779448426:layer:headless-chromium-layer:4" \
make create-func
```


response
```
{
    "Layers": [
        {
            "CodeSize": 11339318,
            "Arn": "arn:aws:lambda:ap-northeast-1:903779448426:layer:awscli-layer:15"
        },
        {
            "CodeSize": 87662979,
            "Arn": "arn:aws:lambda:ap-northeast-1:903779448426:layer:headless-chromium-layer:4"
        }
    ],
    "FunctionName": "headless-chromium-layer-test-func2",
    "LastModified": "2019-01-07T12:43:27.880+0000",
    "RevisionId": "61b4164e-9bde-4c79-995e-f5baf9006279",
    "MemorySize": 1536,
    "Version": "$LATEST",
    "Role": "arn:aws:iam::903779448426:role/service-role/LambdaDefaultRole",
    "Timeout": 30,
    "Runtime": "provided",
    "TracingConfig": {
        "Mode": "PassThrough"
    },
    "CodeSha256": "TCPPMfDY3QSc6Nn0f57eTgYHRpFBA/MFatamwAbG5dQ=",
    "Description": "headless-chromium-layer-test-func",
    "CodeSize": 1243,
    "FunctionArn": "arn:aws:lambda:ap-northeast-1:903779448426:function:headless-chromium-layer-test-func2",
    "Handler": "main"
}
```

(please note: you need `2` layers for this function. The 1st one is [awscli layer](https://github.com/pahud/lambda-layer-awscli) and the 2nd one is the headless chromium layer you just created and published previously.)

# test and validation

```
$ make invoke
```

response:

```
R:nss_util.cc(83)] Failed to create /opt/headless-chromium/.pki/nssdb directory.
[0107/124743.090256:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: ocsp.comodoca.com
[0107/124743.090290:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: ocsp.comodoca.com
[0107/124743.090319:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: crl.comodoca.com
[0107/124743.091068:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: ocsp.comodoca.com
[0107/124743.091094:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: ocsp.comodoca.com
[0107/124743.091118:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: crl.comodoca.com
[0107/124743.091715:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: ocsp.usertrust.com
[0107/124743.091740:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: ocsp.usertrust.com
[0107/124743.091765:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: crl.usertrust.com
[0107/124747.324690:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: RootOcsp.twca.com.tw
[0107/124747.324798:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: RootOcsp.twca.com.tw
[0107/124747.324834:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: RootCA.twca.com.tw
[0107/124747.325936:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: RootOcsp.twca.com.tw
[0107/124747.325954:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: RootOcsp.twca.com.tw
[0107/124747.325969:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: RootCA.twca.com.tw
[0107/124747.338978:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: rootocsp.twca.com.tw
[0107/124747.339006:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: rootocsp.twca.com.tw
[0107/124747.339031:ERROR:nss_ocsp.cc(582)] No URLRequestContext for NSS HTTP handler. host: RootCA.twca.com.tw
[0107/124749.181886:INFO:headless_shell.cc(538)] Written to file /tmp/screenshot.png.
=========[RESPONSE]=======
upload: ../../tmp/screenshot.png to s3://pahud-tmp-nrt/screenshot.png
https://pahud-tmp-nrt.s3.amazonaws.com/screenshot.png?AWSAccessKeyId=ASIA5E3LT6ZVFH5EFEPU&Expires=1546865570&x-amz-security-token=FQoGZXIvYXdzEAYaDM7Jq2cv%2FR%2FyXiAL5SL7AST7jNh%2F%2BxWFEv69frcV8bJxDhApmWphX6rb6NHp0bRextPJKx%2BUZ7tYveDC2xHdsooNIQgnSD%2BnEWPD6PADgQP6MsvEsYuYqWfHv6D5fr4fajIWkxZgOPDzxDud7GO%2BzOKpEZjpGbP5bAbeclHf2WMCgM%2BWQgF8GEEUAoNDuKTRrx6Kyf78jGtGw0%2BizdLfd3SjIU8jDFO2e6%2B28uPglMOE8CajpxkBhf3jjOsqoacAplYCySnHOk%2FEtvGCsmmQbEOlUmIRDJjK%2B8fTSuQrNj0IjoJ2qQakGhSc5DulvJ9jn35k6qxxdwqFFBiBGwVE2NjIXbaI%2FRQErf84KJmKzeEF&Signature=BlNJlGdAcgnyLjtwjsfPuR1aTLk%3D
=========[/RESPONSE]=======
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1313  100    16  100  1297   3275   259k --:--:-- --:--:-- --:--:--  316k
{"status":"OK"}
END RequestId: 6b554111-127a-11e9-b3d3-0317b2c3587b
REPORT RequestId: 6b554111-127a-11e9-b3d3-0317b2c3587b  Init Duration: 44.76 ms Duration: 9125.78 ms    Billed Duration: 9200 ms        Memory Size: 1536 MB    Max Memory Used: 389 MB
```

You will get a presigned URL of the screenshot in the `RESPONSE` like this:

![](https://pbs.twimg.com/media/Dv_35vrU0AAGuTP.jpg)

# SC JP and KR support
![](screenshot-cn.png)
![](screenshot-jp.png)
![](screenshot-kr.png)


