output "this_rds_cluster_arn" {
  description = "The ARN of the RDS cluster"
  value       = "${aws_rds_cluster.this_cluster.*.arn}"
}

output "this_rds_cluster_availability_zones" {
  description = "The availability zone of the RDS cluster"
  value       = "${aws_rds_cluster.this_cluster.*.availability_zones}"
}

output "this_rds_cluster_hosted_zone_id" {
  description = "The canonical hosted zone ID of the RDS cluster (to be used in a Route 53 Alias record)"
  value       = "${aws_rds_cluster.this_cluster.*.hosted_zone_id}"
}

output "this_rds_cluster_id" {
  description = "The RDS cluster ID"
  value       = "${aws_rds_cluster.this_cluster.*.id}"
}

output "this_rds_cluster_endpoint" {
  description = "The RDS cluster endpoint"
  value       = "${aws_rds_cluster.this_cluster.*.endpoint}"
}

output "this_rds_cluster_ro_endpoint" {
  description = "The RDS cluster Readonly endpoint"
  value       = "${aws_rds_cluster.this_cluster.*.reader_endpoint}"
}

output "this_rds_cluster_database_name" {
  description = "The database name"
  value       = "${aws_rds_cluster.this_cluster.*.database_name}"
}

output "this_rds_cluster_master_username" {
  description = "The master username for the database"
  value       = "${aws_rds_cluster.this_cluster.*.master_username}"
}

output "this_rds_cluster_port" {
  description = "The database port"
  value       = "${aws_rds_cluster.this_cluster.*.port}"
}

output "this_rds_cluster_members" {
  description = "The cluster instances that make up the cluster"
  value       = "${aws_rds_cluster.this_cluster.*.cluster_members}"
}
