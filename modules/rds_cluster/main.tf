locals {
  is_aurora = "${element(split("-",var.engine), 0) == "aurora"}"
}

resource "aws_iam_role" "enhanced_monitoring" {
  count = "${var.create_monitoring_role ? 1 : 0}"

  name               = "${var.monitoring_role_name}"
  assume_role_policy = "${file("${path.module}/policy/enhancedmonitoring.json")}"
  tags               = "${merge(map("Name", format("%s", var.monitoring_role_name)), var.tags)}"
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = "${var.create_monitoring_role ? 1 : 0}"

  role       = "${aws_iam_role.enhanced_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_rds_cluster" "this_cluster" {
  count = "${var.create &&  local.is_aurora ? 1 : 0}"

  cluster_identifier                  = "${var.identifier}"
  database_name                       = "${var.database_name}"
  master_username                     = "${var.master_username}"
  master_password                     = "${var.master_password}"
  backup_retention_period             = "${var.backup_retention_period}"
  preferred_backup_window             = "${var.preferred_backup_window}"
  preferred_maintenance_window        = "${var.preferred_maintenance_window}"
  deletion_protection                 = "${var.deletion_protection}"
  skip_final_snapshot                 = "${var.skip_final_snapshot}"
  final_snapshot_identifier           = "${var.final_snapshot_identifier}"
  port                                = "${var.port}"
  availability_zones                  = ["${split(",", var.availability_zone)}"]
  vpc_security_group_ids              = ["${var.vpc_security_group_ids}"]
  snapshot_identifier                 = "${var.snapshot_identifier}"
  storage_encrypted                   = "${var.storage_encrypted}"
  snapshot_identifier                 = "${var.snapshot_identifier}"
  db_subnet_group_name                = "${var.db_subnet_group_name}"
  db_cluster_parameter_group_name     = "${var.db_cluster_parameter_group_name}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"
  engine                              = "${var.engine}"
  engine_version                      = "${var.engine_version}"
  engine_mode                         = "${var.engine_mode}"
  tags                                = "${merge(var.tags, map("Name", format("%s", var.identifier)))}"
  enabled_cloudwatch_logs_exports     = "${var.enabled_cloudwatch_logs_exports}"
  backtrack_window                    = "${var.backtrack_window}"
  replication_source_identifier       = "${var.replication_source_identifier}"
  apply_immediately                   = "${var.apply_immediately}"
  kms_key_id                          = "${var.kms_key_id}"
  iam_roles                           = "${var.iam_roles}"
  source_region                       = "${var.source_region}"
}

resource "aws_rds_cluster_instance" "this_aurora" {
  count = "${var.create &&  local.is_aurora ? length(split(",", var.availability_zone)) : 0}"

  apply_immediately          = "${var.apply_immediately}"
  cluster_identifier         = "${aws_rds_cluster.this_cluster.id}"
  identifier                 = "${var.identifier}-${count.index}"
  instance_class             = "${var.instance_class}"
  publicly_accessible        = "${var.publicly_accessible}"
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  monitoring_interval        = "${var.monitoring_interval}"
  monitoring_role_arn        = "${coalesce(var.monitoring_role_arn, join("", aws_iam_role.enhanced_monitoring.*.arn))}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  tags                       = "${merge(var.tags, map("Name", format("%s", var.identifier)))}"
  copy_tags_to_snapshot      = "${var.copy_tags_to_snapshot}"
  db_parameter_group_name    = "${var.db_parameter_group_name}"
  engine                     = "${var.engine}"
  engine_version             = "${var.engine_version}"
  promotion_tier             = "${var.promotion_tier}"
}
