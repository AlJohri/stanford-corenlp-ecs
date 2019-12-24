#!/usr/bin/env bash

set -e

export CLUSTER=default
export ECS_CLUSTER=default
export COMPOSE_PROJECT_NAME=corenlp
export AWS_PROFILE=al2
export AWS_REGION=us-east-1

error() {
    >&2 echo "[ERROR] $@"
}

case $1 in

    up)

        KEY_PAIR_NAME=default
        PEM_FILE_PATH="$HOME/.ssh/${AWS_PROFILE}_${KEY_PAIR_NAME}.pem"

        # Get Default VPC
        VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[?IsDefault==`true`].VpcId' --output text)

        SUBNET_IDS=$(aws ec2 describe-subnets \
            --query "Subnets[?VpcId==\`$VPC_ID\`].SubnetId" --output text  | tr -s '[:blank:]' ',')

        # Get Default Security Group
        SECURITY_GROUP=$(aws ec2 describe-security-groups \
            --group-names default \
            --query 'SecurityGroups[0].GroupId' --output text)

        # aws ec2 authorize-security-group-ingress \
        #     --group-name default \
        #     --ip-permissions IpProtocol=-1,IpRanges='[{CidrIp=0.0.0.0/0}]'

        # Ensure `default` key-pair exists
        CHECK_KEY_PAIR=$(aws ec2 describe-key-pairs --query "KeyPairs[?KeyName==\`$KEY_PAIR_NAME\`].KeyName" --output text)
        if [ -z $CHECK_KEY_PAIR ]; then
            echo "$KEY_PAIR_NAME keypair does not exist. creating..."
            PEM=$(aws ec2 create-key-pair --key-name default --query 'KeyMaterial' --output text)
            touch "$PEM_FILE_PATH"
            echo "$PEM" > "$PEM_FILE_PATH"
            chmod 600 "$PEM_FILE_PATH"
            echo "created ${KEY_PAIR_NAME} key pair at ${PEM_FILE_PATH}"
        fi

        ecs-cli up \
            --cluster "$CLUSTER" \
            --launch-type EC2 \
            --instance-type "a1.xlarge" \
            --size 3 \
            --keypair "$KEY_PAIR_NAME" \
            --vpc "$VPC_ID" \
            --subnets "$SUBNET_IDS" \
            --security-group "$SECURITY_GROUP" \
            --capability-iam

        ;;

    scale)

        ecs-cli scale --capability-iam "$@"

        ;;

    *)
        ecs-cli "$@"
        ;;

esac