require "../src/crystal_iso8583"

# Maps an MTI string to the typed message class that builds/parses it.
#
# ISO 8583 MTIs encode the message version in their first digit (0 → 1987,
# 1 → 1993 in this repo's Msg0100/Msg1100-style naming), so the version
# never needs to be passed separately once the MTI is known.
module MessageRegistry
  BUILDERS = {
    "0100" => ->{ CrystalIso8583::V1987::Msg0100.new },
    "1100" => ->{ CrystalIso8583::V1993::Msg1100.new },
    "1110" => ->{ CrystalIso8583::V1993::Msg1110.new },
    "1120" => ->{ CrystalIso8583::V1993::Msg1120.new },
    "1121" => ->{ CrystalIso8583::V1993::Msg1121.new },
    "1130" => ->{ CrystalIso8583::V1993::Msg1130.new },
    "1420" => ->{ CrystalIso8583::V1993::Msg1420.new },
    "1421" => ->{ CrystalIso8583::V1993::Msg1421.new },
    "1430" => ->{ CrystalIso8583::V1993::Msg1430.new },
    "1804" => ->{ CrystalIso8583::V1993::Msg1804.new },
    "1814" => ->{ CrystalIso8583::V1993::Msg1814.new },
  }

  def self.for_mti(mti : String)
    builder = BUILDERS[mti]?
    unless builder
      STDERR.puts "Unsupported MTI: #{mti} (supported: #{BUILDERS.keys.join(", ")})"
      exit 1
    end
    builder.call
  end

  def self.version_for_mti(mti : String) : String
    mti.starts_with?("0") ? "1987" : "1993"
  end
end
