# Webpacker::Compiler.env["PAYJP_PK"] = ENV["PAYJP_PUBLIC_KEY"]
Webpacker::Compiler.env["PAYJP_PK"] = Rails.application.credentials.payjp[:PAYJP_PUBLIC_KEY]