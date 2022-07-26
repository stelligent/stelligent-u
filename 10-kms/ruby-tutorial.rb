# using the aws sdk for ruby in your program 
# add a require statement to the top of your ruby source file 
require 'aws-sdk'

# creating an s3 resource 
s3 = Aws::S3::Resource.new(region: 'us-west-2')

# creating a bucket 
my_bucket = s3.bucket('my_bucket')
my_bucket.create 

# add a file 
name = File.basename 'my_file'
obj = s3.bucket('my_bucket').object(name)
obj.upload_file('my_file')