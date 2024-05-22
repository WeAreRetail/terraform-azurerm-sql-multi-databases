<!-- markdownlint-disable-file MD024 MD041 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2024-05-22

### Improvement

- Output database IDs in `databases_configuration`.
- Allow to set the `max_size_gb`.

## [1.3.2] - 2024-05-22

### Bug fix

- Fix `sqlsso` version.

## [1.3.1] - 2024-05-09

### Bug fix

- Fix `identity_type` validation.

## [1.3.0] - 2024-05-09

### Improvement

- Allow to set the SQL Server identity to the project-managed identity with `identity_use_project_msi`.

## [1.2.0] - 2024-05-07

### Improvement

- Allow to set the SQL Server identity.

## [1.1.0] - 2024-03-25

### Improvement

- Set default values for the database object.
- Expose the computed database configuration.
- Limit `min_capacity` and `auto_pause_delay_in_minutes` to Serverless SKUs.
- Improve variables and output descriptions.

## [1.0.0] - 2024-08-01

### Added

- Initial Release to Open Source
