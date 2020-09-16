# EFS-MON

This repository contains rudimentary code to create an ec2 instance ready to
help work with and debug an EFS storage, basically it just provides a convenient
way to ask for a small ec2 instance in a specific subnet and VPC. For the moment
both of those values should be completed in the terragrunt.hcl file referencing
this module (they aren't detected from the existing infrastructure).

A sample terragrunt usage might look like

```bash
terraform {
    source = "https://github.com/pimsmath/efs-mon//?ref=v0.1.0"
}

remote_state {
    backend = "s3"
    config  = {
        encrypt        = true
        region         = "ca-central-1"
        bucket         = "syzygy-inf-k8s"
        key            = "${path_relative_to_include()}/terraform.tfstate"
        dynamodb_table = "1-terraform-locks"
    }
}

terraform {
    extra_arguments "bucket" {
        commands = get_terraform_commands_that_need_vars()
    }
}


inputs = {
   region     = "ca-central-1"
   profile    = "default"
   vpc_id     = "vpc-XXXXXXXXXXXXXXXXX"
   subnet_id  = "subnet-XXXXXXXXXXXXXXXXX"
   ssh_key    = "id_AWS"
}
```

When the instance is deployed install `amazon-efs-utils` and mount the
filesystem
```bash
$ sudo yum insatll amazon-efs-utils`
$ sudo mkdir /mnt/efs
$ sudo mount -t efs fs-XXXXXXX:/ /mnt/efs
```
