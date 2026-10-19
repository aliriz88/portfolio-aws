"""Visitor counter: atomically adds 1 to a DynamoDB item and returns the total."""

import json
import os

import boto3

# Created once per container and reused across invocations
table = boto3.resource("dynamodb").Table(os.environ["TABLE_NAME"])


def handler(event, context):
    # ADD is atomic: two visitors at the same instant are both counted.
    # "visit_count" because "count" is a DynamoDB reserved word.
    response = table.update_item(
        Key={"id": "visitors"},
        UpdateExpression="ADD visit_count :inc",
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW",
    )
    count = int(response["Attributes"]["visit_count"])

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"count": count}),
    }
