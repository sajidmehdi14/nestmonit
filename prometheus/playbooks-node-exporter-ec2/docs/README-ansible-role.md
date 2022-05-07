# Filter ec2 dynamic inventory with tags

- vi aws_ec2.yaml
```
---
plugin: aws_ec2
boto_profile: default

regions:
  - us-east-1

exclude_filters:
- tag:Name:
  - 'aws-cloud9-aws-devvelopment-d20270165aa14f4b8006aa808b89a84a'

# Purpose": "CodePipeline
include_filters:
- tag:Purpose:
  - 'CodePipeline'
- tag:Name:
  - 'my_third_tag'
```

## filter running instances with public ip
```
---
plugin: aws_ec2
boto_profile: default

regions:
  - us-east-1

filters:
  # All instances with their state as `running`
  instance-state-name: running
keyed_groups:
  - prefix: tag
    key: tags
compose:
  ansible_host: public_dns_name
```

## filter running instances with public ip and group by vpc-id
```
---
plugin: aws_ec2
boto_profile: default

regions:
  - us-east-1

filters:
  # All instances with their state as `running`
  instance-state-name: running
keyed_groups:
  - prefix: tag
    key: tags
compose:
  ansible_host: public_dns_name

#groups:
#  libvpc: vpc_id == 'vpc-####'

```

## Run sample playbook

```
ansible-inventory -i aws_ec2.yaml --list
```

## output of above command
```
    "all": {
        "children": [
            "aws_ec2",
            "tag_Name_Swarm1_registry",
            "tag_Purpose_CodePipeline",
            "ungrouped"
        ]
    },
    "aws_ec2": {
        "hosts": [
            "ec2-3-85-201-128.compute-1.amazonaws.com",
            "ec2-3-86-185-172.compute-1.amazonaws.com"
        ]
    },
    "tag_Name_Swarm1_registry": {
        "hosts": [
            "ec2-3-86-185-172.compute-1.amazonaws.com"
        ]
    },
    "tag_Purpose_CodePipeline": {
        "hosts": [
            "ec2-3-85-201-128.compute-1.amazonaws.com"
        ]
    }
}
```

## run sample play book on one of above groups
```
ansible-playbook update_env.yaml -i aws_ec2.yaml --limit tag_Name_Swarm1_registry -vv
```
