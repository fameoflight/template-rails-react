json_string = "{\"password\":\"test\",\"otp\":\"123456\"}"
decoded = Jason.decode!(json_string)
IO.inspect(decoded, label: "Decoded JSON")
IO.inspect(decoded["otp"], label: "OTP value")
IO.inspect(is_binary(decoded["otp"]), label: "Is string?")