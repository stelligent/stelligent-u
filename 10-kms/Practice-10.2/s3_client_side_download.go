package main

import (
    "fmt"
    "io/ioutil"
    "log"

	"github.com/aws/aws-sdk-go/aws"
    "github.com/aws/aws-sdk-go/aws/session"
    "github.com/aws/aws-sdk-go/service/s3"
    "github.com/aws/aws-sdk-go/service/s3/s3crypto"
	"os"
)

var (
    bucket = "kms-bucket-ndambi"
    key    = "clientside.txt"
)

func main() {
    sess := session.New(&aws.Config{
		Region:      aws.String("us-east-1"),})

    client := s3crypto.NewDecryptionClient(sess)

    input := &s3.GetObjectInput{
        Bucket: &bucket,
        Key:    &key,
    }

    result, err := client.GetObject(input)
    // Aside from the S3 errors, here is a list of decryption client errors:
    //   * InvalidWrapAlgorithmError - returned on an unsupported Wrap algorithm
    //   * InvalidCEKAlgorithmError - returned on an unsupported CEK algorithm
    //   * V1NotSupportedError - the SDK doesn’t support v1 because security is an issue for AES ECB
    // These errors don’t necessarily mean there’s something wrong. They just tell us we couldn't decrypt some data.
    // Users can choose to log this and then continue decrypting the data that they can, or simply return the error.
    if err != nil {
        log.Fatal(err)
    }

    // Let's read the whole body from the response
    b, err := ioutil.ReadAll(result.Body)
    if err != nil {
        log.Fatal(err)
    }
    //fmt.Println(string(b))

	file, err := os.Create("NewFile.txt")
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Fprintf(file, "%v\n", string(b))
}
