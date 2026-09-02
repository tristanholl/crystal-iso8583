# crystal-iso8583

[![CI](https://github.com/tristanholl/crystal-iso8583/actions/workflows/ci.yml/badge.svg)](https://github.com/tristanholl/crystal-iso8583/actions/workflows/ci.yml)

A Crystal showcase for processing ISO 8583 financial transaction messages —
demonstrating typed message handling, configurable wire encodings, and
transport framing as a foundation for building against a specific
processor's or card scheme's interface.

ISO 8583 is the international standard for financial transaction
card-originated messages. It defines a message format and a communication
flow for systems that exchange electronic transactions made by cardholders
using payment cards.

## Why crystal-iso8583

- **Type safety where it matters.** Typed message classes catch invalid field
  access at compile time and missing required fields at build time, with
  errors naming the exact field involved.
- **Models real-world dialects.** Payment networks rarely implement
  textbook ISO 8583. A configurable codec lets you mix and match wire
  encodings per concern (MTI, length prefixes, numeric data, text data),
  showing how to adapt the message handling to the dialect a given
  processor or network actually speaks.
- **Zero runtime dependencies.** Nothing to audit beyond the Crystal standard
  library — a meaningful property for institutions with strict
  dependency-review requirements.
- **Two layers, one library.** A typed, ergonomic API for known message types
  and a generic API for proprietary extensions or tooling that needs to
  operate on arbitrary messages.

## Features

**Protocol coverage**
- ISO 8583:1987 and ISO 8583:1993 message versions
- 10 typed message classes per version (authorization/financial requests and
  responses, reversals, issuer requests, network management, echo tests) plus
  a per-version `MessageFactory` for constructing them
- Primary and secondary bitmap support (fields 1–128), managed automatically
- Fixed, LLVAR, LLLVAR, and LLLLVAR field length encoding
- Numeric (N), alphanumeric (AN), alphanumeric+special (ANS), binary (B), and
  track data (Z, ISO 7813) data types

**Wire encoding**
- ASCII, BCD, and EBCDIC (Code Page 037) codecs
- A `Configurable` codec that independently selects the encoding for the MTI,
  length prefixes, numeric fields, and text fields — supporting mixed-encoding
  networks such as VisaNet BASE I (BCD-packed MTI/numeric data, binary length
  prefixes, EBCDIC text)
- Track 2 BCD packing with correct handling of the `=` separator and padding

**Transport**
- Pluggable header/framing strategies for stripping and wrapping
  transport-layer envelopes: fixed-length headers (TPDUs, proprietary tags)
  and ASCII decimal length prefixes (the common TCP framing convention)

**Reliability**
- A dedicated error hierarchy (`ParseError`, `BuildError`, `DictionaryError`)
  so failure modes are explicit and catchable
- Optional debug trace logging in the parser (offsets, field IDs, encodings,
  raw and decoded values) for diagnosing wire-format issues
- JSON serialization of parsed and built messages

**Engineering**
- Clean, zero-dependency Crystal codebase
- Requires Crystal ≥ 1.14.0

## Installation

Add to your `shard.yml`:

```yaml
dependencies:
  crystal_iso8583:
    github: tristanholl/crystal-iso8583
```

Then run:

```
shards install
```

## Usage

### Typed messages (recommended)

Each MTI has a dedicated class with named field accessors. Invalid field names are
caught at compile time; missing required fields are caught when you call `build`.

```crystal
require "crystal_iso8583"

codec = CrystalISO8583::Shared::Codec::ASCII.new

# Build a 1100 authorization request
bytes = CrystalISO8583::V1993::Msg1100.new.tap do |m|
  m.iso002 = "434971******1380"  # PAN
  m.iso003 = "310000"            # Processing Code
  m.iso004 = "000000000000"      # Amount
  m.iso049 = "978"               # Currency Code
  m.iso102 = "505000209047     " # Account Identification
end.build(codec)

# Parse an incoming response
response = CrystalISO8583::V1993::Msg1110.parse(bytes, codec)
puts response.iso039  # Response Code
puts response.iso038  # Authorization ID Response
```

### Generic messages

When you need to work with arbitrary or unknown MTIs, use the lower-level
`Message` type directly.

```crystal
require "crystal_iso8583"

dict  = CrystalISO8583::V1993::DataDictionary.fields
codec = CrystalISO8583::Shared::Codec::ASCII.new

bytes  = CrystalISO8583::Shared::Builder.new(dict, codec).build(message)
parsed = CrystalISO8583::Shared::Parser.new(dict, codec).parse(bytes)
puts parsed.fields[39]  # Response Code by field number
```

### Mixed-encoding networks

Many real networks don't use a single uniform encoding. The `Configurable`
codec lets you select the wire format independently for the MTI, length
prefixes, numeric fields, and text fields:

```crystal
require "crystal_iso8583"

codec = CrystalISO8583::Shared::Codec::Configurable.new(
  mti_encoding: CrystalISO8583::MtiEncoding::BCD,
  length_encoding: CrystalISO8583::LengthEncoding::Binary,
  numeric_encoding: CrystalISO8583::NumericEncoding::BCD,
  text_encoding: CrystalISO8583::TextEncoding::EBCDIC,
)

bytes = CrystalISO8583::V1987::Msg0100.new.tap do |m|
  m.iso002 = "434971******1380"
  m.iso003 = "310000"
  m.iso004 = "000000000000"
end.build(codec)
```

### Transport framing

ISO 8583 messages are typically wrapped in a transport-layer header before
being sent over the wire (a TPDU, a proprietary tag, or a length prefix).
Header strategies handle stripping and re-wrapping that envelope:

```crystal
require "crystal_iso8583"

framing = CrystalISO8583::Shared::Header::AsciiLengthPrefix.new(digits: 4)

framed = framing.wrap(bytes)        # prepend a 4-digit ASCII length prefix
payload = framing.strip(framed)     # recover the raw ISO 8583 message
```

## Supported message types

| MTI (1987) | MTI (1993) | Description |
|---|---|---|
| 0100 | 1100 | Authorization/financial request |
| 0110 | 1110 | Authorization/financial response |
| 0120 | 1120 | Request reversal |
| 0121 | 1121 | Reversal response |
| 0130 | 1130 | Issuer request |
| 0420 | 1420 | Network management request / reversal request |
| 0421 | 1421 | Network management response / reversal response |
| 0430 | 1430 | Network management reversal |
| 0804 | 1804 | Echo test request |
| 0814 | 1814 | Echo test response |

## API Design

The library uses two complementary layers:

**Typed layer** — one class per MTI (e.g. `V1993::Msg1100`). Named accessors
(`iso002`, `iso003`, …) are generated by a `field` macro. Accessing a non-existent
field name is a compile error. Required fields are validated at `build` time with a
descriptive error naming every missing field.

**Generic layer** — `Message`, `Builder`, `Parser`, `Codec`, and `DataDictionary`.
The typed layer delegates to this for all encoding work. Use it directly when you
need full control, are handling proprietary extensions, or are building tooling that
operates on arbitrary messages.

| Guarantee | When caught |
|---|---|
| Setting a field that doesn't exist on this MTI | Compile time |
| Passing a non-String value to a field setter | Compile time |
| Required fields missing at `build` | Build time (named in error) |
| Field value violates length or type rules | Build time |
| Malformed or truncated wire data | Parse time (`ParseError`) |
| Unknown field in the active data dictionary | `DictionaryError` |

## Development

Requires Docker.

```
make build    # build image
make test     # run specs
make lint     # check formatting
make console  # bash in container
```

## Contributing

Contributions are welcome — bug reports, feature requests, and pull requests
all help make this a better reference and foundation for people building
ISO 8583 integrations.

1. **Open an issue first for non-trivial changes.** This avoids duplicated
   effort and lets us agree on the approach before you invest time in an
   implementation.
2. **Fork the repository and create a feature branch** off `master`.
3. **Write specs for any new behavior.** The existing `spec/` suite covers
   codecs, bitmaps, message types, and error handling — new code should
   follow the same pattern.
4. **Run the full check suite before opening a PR:**
   ```
   make lint   # crystal tool format --check
   make test   # crystal spec
   ```
   Both must pass; CI runs the same checks on every push and pull request.
5. **Keep commits focused and messages descriptive** — explain why a change
   is needed, not just what changed.
6. **Open a pull request against `master`**, describing the motivation and
   any relevant context (e.g. the network/dialect a fix targets).

By contributing, you agree that your contributions will be licensed under the
project's [MIT license](LICENSE).

## License

MIT — see [LICENSE](LICENSE).
