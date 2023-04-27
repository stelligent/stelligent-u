import json
import subprocess

cred_path = r'/Users/paschal.onor/.aws/credentials'

f = open(cred_path).read()
existing = {}
for i in f.split('\n'):
    if '[' in i and ']' in i:
        key = i[1:-1]
        existing[key] = {}
    elif i:
        existing[key][i.split()[0].strip()] = i.split()[-1].strip()
token = input('Enter your token: ')
cmd = 'aws sts get-session-token '\
    '--serial-number arn:aws:iam::324320755747:mfa/paschal.onor.labs ' \
    f'--token-code {token}'
print(cmd)
temp_creds = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE)
json_data = temp_creds.stdout.decode()
print(json_data)
cred_to_json = json.loads(json_data)['Credentials']
existing['temp'] = {
    'output': 'json',
    'region': 'us-east-1',
    'aws_access_key_id': cred_to_json['AccessKeyId'],
    'aws_secret_access_key': cred_to_json['SecretAccessKey'],
    'aws_session_token': cred_to_json['SessionToken']
}
to_file = ''
for profile, data in existing.items():
    to_file += f'[{profile}]\n'
    for key, value in data.items():
        to_file += f'{key} = {value}\n'

print(to_file, file=open(cred_path, 'w'))
