#!/bin/bash
# ansible-playbook playbook.yml  -i aws_ec2.yaml

ansible-playbook playbook.yml  -i aws_ec2.yaml --limit tag_Name_Swarm1_registry -vv
