{:ok, _} = Application.ensure_all_started(:mimic)

Mimic.copy(Calendar)
Mimic.copy(Nimble.Phx.Gen.Template.Hex.Package)

ExUnit.start()
