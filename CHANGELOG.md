# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.0] - 2026-04-20

### Breaking

- `uk_input`, `uk_checkbox`, `uk_radio`, and `uk_range` no longer accept a `label`
  attribute. Pass label content via the `<:label>` slot instead. This enables
  arbitrary HEEx in labels (required markers, links, icons).

  Migration:

  ```diff
  - <.uk_input field={@form[:email]} label="Email" />
  + <.uk_input field={@form[:email]}>
  +   <:label>Email</:label>
  + </.uk_input>
  ```

### Changed

- `uk_table` slots replaced with composable function components.

### Added

- Configurable error translator for i18n support.
- `uk-*` prefixes allowed on any function component that accepts `rest` attributes.

### Fixed

- Form validation classes on inputs now apply correctly after JS update.

## [0.5.4]

- Version bump; prior history tracked in git log.
