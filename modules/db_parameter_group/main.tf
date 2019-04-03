locals {
  description = "${coalesce(var.description, "Database parameter group for ${var.identifier}")}"
  is_aurora   = "${element(split("-",var.engine), 0) == "aurora"}"
}

resource "aws_db_parameter_group" "this_no_prefix" {
  count = "${var.create && ! var.use_name_prefix && ! local.is_aurora ? 1 : 0}"

  name        = "${var.name}"
  description = "${local.description}"
  family      = "${var.family}"

  parameter = ["${var.parameters}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "this" {
  count = "${var.create && var.use_name_prefix && ! local.is_aurora ? 1 : 0}"

  name_prefix = "${var.name_prefix}"
  description = "${local.description}"
  family      = "${var.family}"

  parameter = ["${var.parameters}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.identifier)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_parameter_group" "this_cluster_pg" {
  count = "${var.create && var.use_name_prefix && local.is_aurora ? 1 : 0}"

  name_prefix = "${var.name_prefix}"
  description = "${local.description}"
  family      = "${var.family}"

  parameter = ["${var.parameters}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.identifier)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_parameter_group" "this_cluster_pg_no_prefix" {
  count = "${var.create && ! var.use_name_prefix  &&  local.is_aurora ? 1 : 0}"

  name        = "${var.name}"
  description = "${local.description}"
  family      = "${var.family}"

  parameter = ["${var.parameters}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"

  lifecycle {
    create_before_destroy = true
  }
}
