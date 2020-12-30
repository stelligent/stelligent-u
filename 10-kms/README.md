# Topic 10: Key Management Service (KMS)

<!-- TOC -->

- [Topic 10: Key Management Service (KMS)](#topic-10-key-management-service-kms)
  - [Lesson 10.1: Introduction to KMS](#lesson-101-introduction-to-kms)
    - [Principle 10.1](#principle-101)
    - [Practice 10.1](#practice-101)
      - [Lab 10.1.1: Create a KMS CMK](#lab-1011-create-a-kms-cmk)
      - [Lab 10.1.2 : Create a KMS Alias](#lab-1012--create-a-kms-alias)
      - [Lab 10.1.3: Encrypt a text file with your KMS CMK](#lab-1013-encrypt-a-text-file-with-your-kms-cmk)
      - [Lab 10.1.4: Decrypt a ciphertext file](#lab-1014-decrypt-a-ciphertext-file)
    - [Retrospective 10.1](#retrospective-101)
      - [Question: Decrypting the Ciphertext File](#question-decrypting-the-ciphertext-file)
      - [Question: KMS Alias](#question-kms-alias)
  - [Lesson 10.2: Implementation of KMS Keys in S3](#lesson-102-implementation-of-kms-keys-in-s3)
    - [Principle 10.2](#principle-102)
    - [Practice 10.2](#practice-102)
      - [Lab 10.2.1: Client Side Encryption of S3 Object](#lab-1021-client-side-encryption-of-s3-object)
      - [Lab 10.2.2: Delete your CMK](#lab-1022-delete-your-cmk)
        - [Question: CMK](#question-cmk)
    - [Retrospective 10.2](#retrospective-102)

<!-- /TOC -->

## Lesson 10.1: Introduction to KMS

### Principle 10.1

*AWS Key Management Service (AWS KMS) is a managed service that makes it
easy for you to create and control the encryption keys used to encrypt
your data.*

### Practice 10.1

Rather than storing the encryption keys ourselves, Amazon securely
stores them and provides the ability to disperse and use keys to others
via IAM. The following labs will introduce you to the fundamental resources in
KMS: KMS Customer Master Keys (CMKs) and KMS Aliases.

#### Lab 10.1.1: Create a KMS CMK

Create a CFN Template that
[creates a CMK key in KMS](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-kms-key.html):

- For a key policy, set your IAM user as Key Administrator and as a Key User

#### Lab 10.1.2 : Create a KMS Alias

Update your CFN template to add a KMS Alias with a snazzy name.
Associate your CMK with this alias.

#### Lab 10.1.3: Encrypt a text file with your KMS CMK

Use the AWS KMS CLI to encrypt a plaintext file with a secret message
(maybe that combo to the safe, or your luggage password). Send your file
to a colleague with administrator access.

#### Lab 10.1.4: Decrypt a ciphertext file

Use the KMS CLI to now decrypt a ciphertext file.

### Retrospective 10.1

#### Question: Decrypting the Ciphertext File

_For decrypting the ciphertext file, why didn't you have to specify a key? How
did you have permission to decrypt?_

#### Question: KMS Alias

_Why is it beneficial to use a KMS Alias?_

## Lesson 10.2: Implementation of KMS Keys in S3

### Principle 10.2

For AWS S3, you've seen in a previous lab about setting a KMS key to be
used with Server Side Encryption. Additionally, a KMS key can be used
for client side encryption of S3 assets. Client side encryption adds an
extra layer of security by encrypting information before transmission to
S3.

### Practice 10.2

Amazon has integrated KMS into many of their services (check out the
full list:
[https://docs.aws.amazon.com/kms/latest/developerguide/service-integration.html](https://docs.aws.amazon.com/kms/latest/developerguide/service-integration.html)
). In the following labs, we'll take your existing CMK and begin using
them for a practical purposes: client side encryption of S3 objects.

Ruby SDK for Encryption client:
[https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/EncryptionV2/Client.html](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/EncryptionV2/Client.html)

#### Lab 10.2.1: Client Side Encryption of S3 Object

Use the ruby-sdk to create a script that will:

- Encrypt a local plaintext file and upload to S3

- Read back the encrypted ciphertext from the uploaded file

- Pull down and decrypt the file, saving as another name.

#### Lab 10.2.2: Delete your CMK

Delete your KMS CFN Stack.

##### Question: CMK

_What happened to your CMK? Why?_

### Retrospective 10.2

Check out the code for [stelligent/crossing](https://github.com/stelligent/crossing)
and [stelligent/keystore](https://github.com/stelligent/keystore)
on GitHub for tools that simplify using KMS encrypted resources.
