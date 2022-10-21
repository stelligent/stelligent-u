import boto3

print('Loading function')

sns = boto3.client('sns')
s3 = boto3.resource('s3')


def lambda_handler(event, context):
    """
    Subscribes an endpoint to the topic. Some endpoint types, such as email,
    must be confirmed before their subscriptions are active. When a subscription
    is not confirmed, its Amazon Resource Number (ARN) is set to
    'PendingConfirmation'.

    :param topic: The topic to subscribe to.
    :param protocol: The protocol of the endpoint, such as 'sms' or 'email'.
    :param endpoint: The endpoint that receives messages, such as a phone number
                      or an email address.
    :return: The newly added subscription.
    """
    topic = sns.create_topic(Name='SampleTopic')
    topic_arn = topic["TopicArn"]
    # Create email subscription
    response = sns.subscribe(TopicArn=topic_arn, Protocol="email", Endpoint="desmond.ndambi@stelligent.com")
    subscription_arn = response["SubscriptionArn"]

    s3_bucket_name='desmond-sam-bucket'

    my_bucket=s3.Bucket(s3_bucket_name)
    bucket_list = []
    for file in my_bucket.objects.all():
        # Un comment this to specify a files with particular extensions e.g .json. .csv
        # file_name=file.key
        # if file_name.find(".json")!=-1:
        bucket_list.append(file.key)
    length_bucket_list=print(len(bucket_list))
    print(bucket_list[0:10])
    
