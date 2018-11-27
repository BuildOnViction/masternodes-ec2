# Step-by-step to provision infrastructure of masternodes on EC2

## Bring up

1. Configuration

Update `config.json` file at below fields (with each region, you need to create config,json):

- "accessKeyId": AWS access key
- "secretAccessKey": AWS secret key
- "sshKeyName": specify your ssh key registered on DO
- "privateKeyPath": path to the private ssh key on your machine
- "coinbasePrivateKeySun": private key of the SUN masternode
- "node": put in information for each masternode

2. Join a node to testnet (select for each region)

```
$ ./up.sh main
```

3. Start up other masternodes

```
$ ./up.sh <region>
```

## Bring down

```
$ ./down.sh main
$ ./down.sh node
```

## Update code and reload
```
VAGRANT_VAGRANTFILE=Vagrantfile.main vagrant ssh -c "consul kv put tomochain/reset 1"
```
