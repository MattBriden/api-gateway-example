from uuid import uuid4


def lambda_handler(event, _context):
    authorization = event['headers'].get('Authorization') or event['headers'].get('authorization')
    effect = authorization if authorization == 'Allow' else 'Deny'
    arn = event['methodArn']
    principal_id = str(uuid4())
    return {
        "principalId": principal_id,
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "execute-api:Invoke",
                    "Effect": effect,
                    "Resource": arn
                }
            ]
        }
    }