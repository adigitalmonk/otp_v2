import Config

config :big_brother, Breaker, %{
  duplicates: [
    duplicates: true
  ],
  no_duplicates: [
    duplicates: false
  ]
}
