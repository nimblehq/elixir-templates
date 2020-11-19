{:ok, _} = Application.ensure_all_started(:mimic)

Mimic.copy(Nimble.Phx.Gen.Template.Hex.Package)

ExUnit.start()
