# import boto3
# import json
# import uuid

# client = boto3.resource('dynamodb')
# table = client.Table("UserProfiles")

# def lambda_handler(event, context):
#     command = event['command']
#     command_map[command](event['payload'])

# def create(user_data):
#     user_data['id'] = uuid.uuid4()
#     table.put_item(Item=user_data)
#     # TODO: Also create Cognito user later

# def update(user_data):
#     table.put_item(Item=user_data)

# def delete(user_data):
#     table.delete_item(Key=user_data)
#     # TODO: Also delete cognito user later


# command_map = {
#     "create": create,
#     "update": update,
#     "delete": delete
# }

def lambda_handler(event, context):
    return 'Hello AWS Lambda, try number two'