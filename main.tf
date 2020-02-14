locals {
  zones                 = map(replace(var.name, ".", "-"), var.name)
  vpc_ids               = { for id in var.vpc_ids : id => id }
  create_delegation_set = var.create_delegation_set && length(var.vpc_ids) == 0 && length(var.delegation_set_id) == 0
}

resource "aws_route53_zone" "zone" {
  for_each = var.create ? local.zones : {}

  name              = each.value
  force_destroy     = var.force_destroy
  delegation_set_id = local.create_delegation_set ? try(var.delegation_set_id, aws_route53_delegation_set.delegation_set[each.key].id) : null

  dynamic "vpc" {
    for_each = local.vpc_ids

    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(
    { Name = replace(each.value, ".", "-") },
    var.tags
  )
}

resource "aws_route53_delegation_set" "delegation_set" {
  for_each = local.create_delegation_set ? local.zones : {}

  reference_name = length(var.delegation_set_reference_name) > 0 ? var.delegation_set_reference_name : each.key
}

locals {
  a_records = {
    for record in var.a_records : replace(record.name, ".", "-") => {
      name    = record.name
      type    = "A"
      ttl     = try(record.ttl, null)
      records = try(record.records, null)
      alias   = try(record.alias, {})
    }
  }

  cname_records = {
    for record in var.cname_records : replace(record.name, ".", "-") => {
      name    = record.name
      type    = "CNAME"
      ttl     = try(record.ttl, null)
      records = try(record.records, null)
      alias   = try(record.alias, {})
    }
  }

  all_records = merge({
    for record in var.records : replace(record.name, ".", "-") => {
      name    = record.name
      type    = record.type
      ttl     = try(record.ttl, null)
      records = try(record.records, null)
      alias   = try(record.alias, {})
    }
  }, local.a_records, local.cname_records)
}

resource "aws_route53_record" "record" {
  for_each = var.create ? local.all_records : {}

  zone_id = aws_route53_zone.zone[replace(var.name, ".", "-")].id
  type    = each.value.type
  name    = each.value.name
  ttl     = each.value.ttl
  records = each.value.records

  dynamic "alias" {
    for_each = each.value.alias

    content {
      name                   = alias.value.alias.name
      zone_id                = alias.value.alias.zone_id
      evaluate_target_health = alias.value.alias.evaluate_target_health
    }
  }
}
