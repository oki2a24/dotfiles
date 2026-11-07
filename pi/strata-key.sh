#!/usr/bin/env bash
# Print the API key of the Strata engine instance the app has loaded.
# Strata writes one instance config per model load; the newest is the live one.
# Pi calls this through the "!command" form of models.json's apiKey, so the
# key stays correct after the GUI loads a different model.
config=$(ls -t "$HOME/.strata/data/native-instances"/*.json 2>/dev/null | head -1)
if [ -z "$config" ]; then
  printf 'strata-local\n'
  exit 0
fi
jq -r '.api_key' "$config"
