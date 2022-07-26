require 'aws-sdk-s3'
Aws.config[:ssl_ca_bundle] = '/usr/local/etc/openssl/cert.pem'

bucket_name = 'stelligent-fidelis-ogunsanmi'
object_key = 'secret.json'
region = 'us-west-2'
kms_key_id = '2955639b-67e9-49c0-94da-19764781d57e'
object_content = File.read(object_key)

s3_encryption_client = Aws::S3::EncryptionV2::Client.new(
    region: region,
    kms_key_id: kms_key_id,
    key_wrap_schema: :kms_context,
    content_encryption_schema: :aes_gcm_no_padding,
    security_profile: :v2
  )

  s3_encryption_client.put_object(
    bucket: bucket_name,
    key: object_key,
    body: object_content
  )

  response = s3_encryption_client.get_object(
    bucket: bucket_name,
    key: object_key
  )

  puts response.body.read