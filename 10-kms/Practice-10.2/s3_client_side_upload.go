/* 
Licensed under the MIT-0 license https://github.com/aws/mit-0
*/
package main

import (
    "log"
    "strings"

    "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
    "github.com/aws/aws-sdk-go/service/kms"
    "github.com/aws/aws-sdk-go/service/s3"
    "github.com/aws/aws-sdk-go/service/s3/s3crypto"
)

var (
    cmkId  = "fbc58ad0-2bac-40fe-96ee-5ebd24d2f006"
    bucket = "kms-bucket-ndambi"
    key    = "clientside.txt"
)

func main() {
	sess, err := session.NewSession(&aws.Config{
		Region:      aws.String("us-east-1"),
		Credentials: credentials.NewSharedCredentials("", "default"),
	})
    // This is our key wrap handler, used to generate cipher keys and IVs for
    // our cipher builder. Using an IV allows more “spontaneous” encryption.
    // The IV makes it more difficult for hackers to use dictionary attacks.
    // The key wrap handler behaves as the master key. Without it, you can’t
    // encrypt or decrypt the data.
    keywrap := s3crypto.NewKMSKeyGenerator(kms.New(sess), cmkId)
    // This is our content cipher builder, used to instantiate new ciphers
    // that enable us to encrypt or decrypt the payload.
    builder := s3crypto.AESGCMContentCipherBuilder(keywrap)
    // Let's create our crypto client!
    client := s3crypto.NewEncryptionClient(sess, builder)

    input := &s3.PutObjectInput{
        Bucket: &bucket,
        Key:    &key,
        Body:   strings.NewReader("Test Client-Side encryption"),
    }

    _, err = client.PutObject(input)
    // What to expect as errors? You can expect any sort of S3 errors, http://docs.aws.amazon.com/AmazonS3/latest/API/ErrorResponses.html.
    // The s3crypto client can also return some errors:
    //  * MissingCMKIDError - when using AWS KMS, the user must specify their key's ARN
    if err != nil {
        log.Fatal(err)
    }
}

