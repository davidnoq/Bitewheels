Geocoder.configure(
  # Geocoding options
  timeout: 5,                 # Geocoding service timeout (secs)
  lookup: :google,            # Name of geocoding service (symbol)
  api_key: ENV['GOOGLE_MAPS_API_KEY'], # API key for geocoding service
  use_https: true,            # Use HTTPS for lookup requests? (if supported)
  units: :mi                  # Default units: :mi for miles or :km for kilometers
)