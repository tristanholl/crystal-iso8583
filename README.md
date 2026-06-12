# crystal-iso8583

A Crystal implementation of the ISO 8583 financial transaction message standard.

ISO 8583 is the international standard for financial transaction card-originated messages. It defines a message format and a communication flow for systems that exchange electronic transactions made by cardholders using payment cards.

## Features

- Parse and build ISO 8583 messages
- Primary and secondary bitmap support (fields 1–128)
- Fixed, LLVAR, and LLLVAR field encoding
- Clean, zero-dependency Crystal library
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

```crystal
require "crystal_iso8583"

# Build a message
msg = CrystalIso8583::Message.new("0200")

field = CrystalIso8583::Field.new(
  id: 2,
  type: CrystalIso8583::FieldType::LLVAR,
  max_length: 19,
  value: "4111111111111111"
)

msg.set_field(field)
puts msg.encode
```

## Development

Requires Docker.

```
make build    # build image
make test     # run specs
make lint     # check formatting
make console  # bash in container
```

## License

MIT — see [LICENSE](LICENSE).
