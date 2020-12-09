Code.put_compiler_option(:warnings_as_errors, true)

{:ok, _} = Application.ensure_all_started(:mimic)

Mimic.copy(Calendar)
Mimic.copy(Nimble.Phx.Gen.Template.Hex.Package)

ExUnit.start()
