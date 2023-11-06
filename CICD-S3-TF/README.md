1. Apply theo thứ tự: remote backend -> CDE -> NonCDE

2. Destroy theo thứ tự: NonCDE -> CDE -> remote backend

3. issue khi sử dụng for_each 
Ví dụ:
    resource "aws_route" "CDE-vpc-private-ap-southeast-1b" {
    for_each = {
        "vpn-s2s-dcviettel5" = "13.10.11.12/32",
        "vpn-s2s-dcviettel4" = "9.10.11.12/32",
        "NonCDE"            = module.vpc.vpc_cidr_block,
        "vpn-s2s-office3"    = "5.6.7.8/32",
    }
    route_table_id         = data.terraform_remote_state.CDE-vpc.outputs.private_route_table_ids["1"]
    destination_cidr_block = each.value
    transit_gateway_id     = aws_ec2_transit_gateway.transit-gateway.id
    }

Nếu bạn đã tạo một route với each.key là "vpn-s2s-dcviettel5" và sau đó bạn đổi tên nó thành "vpn-s2s-dcviettel5-updated" trong for_each, Terraform sẽ thử tạo một route mới với tên "vpn-s2s-dcviettel5-updated" mà không xóa route cũ với tên "vpn-s2s-dcviettel5". Do đó, sẽ xuất hiện lỗi về tạo tài nguyên trùng lặp.
Để tránh lỗi này, nếu bạn muốn thay đổi tên each.key, bạn nên xem xét việc tạo một resource mới với tên mới và xóa tài nguyên cũ bằng cách  thực hiện xóa tay trong giao diện quản lý tài nguyên AWS trước khi apply lại Terraform.

4. Khi apply 2 virtual gateway với 1 tag Name thì terraform sẽ gộp 2 vgw này 1 -> không thể tạo 2 vgw, không thể xóa bằng tf

Ví dụ: muốn đổi thông số của vgw như ip,... 
    1: tạo 1 vgw mới với cấu hình mong muốn, khác tag Name vgw cũ -> terraform apply để tạo vgw mới
    2: đổi transit gateway, vpn connection qua vgw mới -> terraform apply để đổi cấu hình
    3: comment vgw cũ -> terraform apply để xóa vgw cũ


5. Khi muốn thay đổi IP Customer Gateway của VPN
    1: xóa VPN connection
    2: thay đổi IP của Customer Gateway
    3. Tạo lại VPN Connection

6. MSK 
Nếu đổi tên security group (name = "NonCDE-kafka-cluster-sg" ) -> kafka-cluster sẽ bị re-create. KHÔNG đổi tên security group khi đang chạy prod (có thể đổi ở tag để thay thế Name mà vẫn giữ nguyên id của security group)

---> KHÔNG update kafka manual (nhất là phần security settings) vì khi sửa code để match với phần đã add manual sẽ gặp lỗi (lỗi này do API của kafka lỗi chứ ko phải lỗi terraform).

7. s3_bucket_versioning destroy operation errors out with:
    │ Error: deleting S3 Bucket Versioning (nextpay-terraform-backend): operation error S3: PutBucketVersioning, https response error StatusCode: 409, RequestID: SK2B5NYD6GDK746T, HostID: jqUswmzQ6ODr6KAfhPVJa+FpDQf0QPOyQ0C8QcFAWXXmIV8vEon1W+zOtopFU0ciOcoBuyRCeacvMH2mOE0XxQ==, api error OperationAborted: A conflicting conditional operation is currently in progress against this resource. Please try again.

    issue link: https://github.com/hashicorp/terraform-provider-aws/issues/33478

-->>> phải empty s3 bucket (làm tay) bao gồm các object vả versioning trước khi chạy terraform để xóa bucket 

8. KHÔNG commemt file ngw-eip.tf
VỚi yêu cầu sử dụng lại Elastic IP cho NAT Gateway, không comment file ngw-eip.tf

9. cách xóa eks cluster
    9.1 comment file data.tf  dòng 1,2,3
    9.2 comment file eks.tf
    9.3 comment file irsa.tf
    9.4 comment file provider dòng 33 -> 63 sau đó add đoạn code sau

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

    9.5 unset context eks cluster muốn xóa
    9.6 terraform plan & apply

10. HẠN CHẾ add tay subnet route tablet rules , security group rules vì khi add code vào terraform và apply sẽ bị duplicate rule dẫn đến error. Nếu đã add manual, nên xóa phần add manual trước khi apply code terraform 