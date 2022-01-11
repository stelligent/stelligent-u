#!/usr/bin/env python
###############################################################################
## Assumes we can automagically pick up configuration/credentials from your 
## environment: ~/.aws/credentials currently works, 
## ~/.boto, /etc/boto.cfg etc would just be a matter of bind mounting the 
## right directories
###############################################################################
##
## How to run me:
## ... and because I'm not going nuts, you have to be in this directory when you execute this script
## docker run --rm -it -v $(pwd):/opt/cfn -v ~/.aws:/root/.aws --entrypoint python sandbox-devel:1.0 /opt/cfn/stack_generator.py
##
## Docker Image: sandbox-devel:1.0 - is pretty much this: https://github.com/ksgh/sandbox
##

import boto3
from botocore.exceptions import ClientError
import argparse
import json
import sys, os, time

import pprint

pp = pprint.PrettyPrinter(indent=4)

DEFAULT_STACK_NAME = 'ksAutoDefaultStackName'
DEFAULT_BUCKET_NAME = 'ks-boto3-bucket'
## default files live beside this script
DEFAULT_REGIONS_FILE = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'deployment-regions.json')
DEFAULT_TEMPLATE_FILE = os.path.join(os.path.dirname(os.path.realpath(__file__)), 's3-buckets.yaml')

def get_template(abs_file):
    if not os.path.isfile(abs_file):
        print(f'{abs_file} cannot be found.')
        return None
    
    with open(abs_file, 'r') as fh:
        # pyyaml no like !Ref
        #try:
        #    template = yaml.load(fh)
        #except yaml.YAMLError as e:
        #    print(e.message)
        #    return None
        template = fh.read()

    return template

def get_deployment_regions(region_file):
    if not os.path.isfile(region_file):
        print(f'{region_file} cannot be found.')
        return None

    regions = []

    with open(region_file) as fh:
        try:
            _regions = json.load(fh)
        except json.JSONDecodeError as e:
            print(e.message)
            return None
    ## we're basically just safe-guarding against a flat list of regions.
    ## therefore, it will be typical to hit this block as things are now.
    if not isinstance(_regions, list) and 'regions' in _regions:
        regions = _regions.get('regions', [])

    return regions

def get_stack(stack, region):
    ## Basically, everything except for DELETED statuses
    params = {
        'StackStatusFilter': ['CREATE_COMPLETE', 'UPDATE_COMPLETE', 'UPDATE_ROLLBACK_COMPLETE']
    }
    b3c = boto3.client('cloudformation', region_name=region)
    stack_resp = b3c.list_stacks(**params)

    stacks = stack_resp.get('StackSummaries', {})

    if stacks:
        for s in stacks:
            if s['StackName'] == stack:
                return s

    return {}

def create_or_update_stacks(stack, regions, cfn_template):
    errors = []
    for r in regions:
        cur_stack = get_stack(stack, r)
        b3c = boto3.client('cloudformation', region_name=r)

        params = {
            'StackName': stack,
            'TemplateBody': cfn_template,
            'Parameters': [
                {
                    'ParameterKey': 'FriendlyBucketName',
                    'ParameterValue': DEFAULT_BUCKET_NAME
                }
            ]
        }

        try:
            if cur_stack:
                resp = b3c.update_stack(**params)
                verb = 'Updated'
            else:
                resp = b3c.create_stack(**params)
                verb = 'Created'

            sid = resp.get('StackId', '')
            print(f' --> {verb} stack {stack} ({sid})')
        except ClientError as e:
            msg = e.response['Error']['Message']
            print(f' --> {stack}: {r}: {msg}')
            ## so... if 'no updates' IS in the message, we're ✅ 
            if 'no updates' not in msg.lower():
                errors.append(msg)

    return errors

def delete_stacks(stack_name, regions):
    for r in regions:
        params = {
            'StackName': stack_name
        }
        b3c = boto3.client('cloudformation', region_name=r)  
        stack = get_stack(stack_name, r)

        if stack:
            print(f' --> Removing stack: {stack_name} from {r}')
            ## Ugh... returns None. From how they handle statuses I get it...
            ## https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/cloudformation.html#CloudFormation.Client.delete_stack
            ## that can be dealt with... but I'm not going to get into polling in here.
            b3c.delete_stack(**params)
        else:
            print(f' --> Stack "{stack_name}" was not found in {r}')

    return True

def check_s3_for_buckets(bucket_name, regions):
    found_buckets = []
    for r in regions:
        b3c = boto3.client('s3', r)
        try:
            resp = b3c.head_bucket(Bucket=bucket_name)
            msg = f'Bucket {bucket_name} still exists in {r}'
            found_buckets.append(msg)
            print(f' --> ERROR: {msg}')
        except ClientError as e:
            e_code = e.response['Error']['Code']
            if e_code == 404:
                print(f' --> Bucket {bucket_name} not found in {r}')
            elif e_code == 403:
                print(f' --> WARNING: We may not have permissions for {bucket_name} in {r}')
            else:
                print(' --> UNKNOWN REPONSE: {e}'.format(e=e.response['Error']['Message']))

    return found_buckets

def parse_args():
    parser = argparse.ArgumentParser(description='Deploy stacks to regions defined in the associated json file.',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('-s', '--stack-name', type=str, dest='stack_name', default=DEFAULT_STACK_NAME, 
        required=False, help='The name of the stack.')
    parser.add_argument('-d', '--delete', action='store_true', dest='do_delete', required=False,
        help='If provided, we\'ll attempt to nuke all stacks in the defined regions')
    parser.add_argument('-r', '--regions-file', dest='regions_file', required=False, default=DEFAULT_REGIONS_FILE,
        help='Json-structured file with a list of regions nested underneath a "regions" key')
    parser.add_argument('-t', '--template-file', dest='template_file', required=False, default=DEFAULT_TEMPLATE_FILE,
        help='(YAML) This is your standard cloudformation template')

    return parser.parse_args()

def main():
    args            = parse_args()
    stack_name      = args.stack_name
    regions_file    = args.regions_file
    template_file   = args.template_file
    regions         = get_deployment_regions(regions_file)

    if not regions:
        print('There is nothing for us to do if there are no regions defined', file=sys.stderr)
        return False

    if args.do_delete:
        ## specifying the delete flag will cause script execution to stop with this
        ## condition regardless of the result.
        if delete_stacks(stack_name, regions): # which is always true right now...
            print(' --> Successfully deleted stacks.')
            print(' --> Polling S3 for bucket\'s existence in the configured regions.')
            errors = ['_'] # temporary to trigger the first check
            timeout = 300 # 5 minutes
            expiration = time.time() + timeout

            ## guess we're polling 🤷‍♂️ 
            while len(errors) > 0:
                if time.time() > expiration:
                    print(' --> Timed out waiting for buckets to drop!')
                    return False

                time.sleep(1)
                errors = check_s3_for_buckets(DEFAULT_BUCKET_NAME, regions)

            return True
        
        print(' --> ERROR: Unable to delete the following stacks: (and then provide a list)', file=sys.stderr)
        return False

    ###########################################################################
    ## If we're not deleting, we'll move forward

    print(' --> Begin Stack manipulation - regions: {r}'.format(r=', '.join(regions)))

    print(f' --> Loading the template: {template_file}')
    template = get_template(template_file)

    if not template:
        print(f'Unable to properly parse {template_file}', file=sys.stderr)
        return False

    ## No delete flag: create things...
    print(f' --> Creating or Updating stacks ({stack_name})')

    errors = create_or_update_stacks(stack_name, regions, template)
    if len(errors) == 0:
        print(' --> All the things appear to have been successful')
    else:
        print('There is an error in your ways!', file=sys.stderr)
        for e in errors:
            print(' --> {e}')
        return False

    return True

if __name__ == '__main__':
    if main():
        sys.exit(0)

    sys.exit(1)
    