defmodule NimbleTemplate.Projects.ProjectTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.Projects.Project

  describe "#new/1" do
    @tag mix_project?: true
    test "given mix project, returns project without web modules and paths", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        project = Project.new(mix: true)

        assert project.base_module == "NimbleTemplate"
        assert project.base_path == nil
        assert project.base_test_path == nil
        assert project.otp_app == :nimble_template
        assert project.web_module == nil
        assert project.web_path == nil
        assert project.web_test_path == nil
        assert project.mix_project? == true
        assert project.web_project? == false
        assert project.live_project? == false
        assert project.api_project? == false
      end)
    end

    @tag mix_project?: true, opts: "--module=SampleCustomModule"
    test "given mix project with a custom module name, returns project with valid base module", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        project = Project.new(mix: true)

        assert project.base_module == "SampleCustomModule"
        assert project.otp_app == :nimble_template
      end)
    end

    test "given web project, returns valid project with valid modules and paths", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        project = Project.new(web: true)

        assert project.base_module == "NimbleTemplate"
        assert project.base_path == "lib/nimble_template"
        assert project.base_test_path == "test/nimble_template"
        assert project.otp_app == :nimble_template
        assert project.web_module == "NimbleTemplateWeb"
        assert project.web_path == "lib/nimble_template_web"
        assert project.web_test_path == "test/nimble_template_web"
        assert project.mix_project? == false
        assert project.web_project? == true
        assert project.live_project? == false
        assert project.api_project? == false
      end)
    end

    @tag opts: "--module=SampleCustomModule"
    test "given web project with a custom module name, returns valid project with valid modules and paths",
         %{
           test_project_path: test_project_path
         } do
      in_test_project!(test_project_path, fn ->
        project = Project.new(web: true)

        assert project.base_module == "SampleCustomModule"
        assert project.base_path == "lib/nimble_template"
        assert project.base_test_path == "test/nimble_template"
        assert project.otp_app == :nimble_template
        assert project.web_module == "SampleCustomModuleWeb"
        assert project.web_path == "lib/nimble_template_web"
        assert project.web_test_path == "test/nimble_template_web"
        assert project.mix_project? == false
        assert project.web_project? == true
        assert project.live_project? == false
        assert project.api_project? == false
      end)
    end

    @tag live_project?: true
    test "given live project, returns valid project with valid modules and paths", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        project = Project.new(live: true)

        assert project.base_module == "NimbleTemplate"
        assert project.base_path == "lib/nimble_template"
        assert project.base_test_path == "test/nimble_template"
        assert project.otp_app == :nimble_template
        assert project.web_module == "NimbleTemplateWeb"
        assert project.web_path == "lib/nimble_template_web"
        assert project.web_test_path == "test/nimble_template_web"
        assert project.mix_project? == false
        assert project.web_project? == true
        assert project.live_project? == true
        assert project.api_project? == false
      end)
    end

    @tag live_project?: true, opts: "--module=SampleCustomModule"
    test "given live project with a custom module name, returns valid project with valid modules and paths",
         %{
           test_project_path: test_project_path
         } do
      in_test_project!(test_project_path, fn ->
        project = Project.new(live: true)

        assert project.base_module == "SampleCustomModule"
        assert project.base_path == "lib/nimble_template"
        assert project.base_test_path == "test/nimble_template"
        assert project.otp_app == :nimble_template
        assert project.web_module == "SampleCustomModuleWeb"
        assert project.web_path == "lib/nimble_template_web"
        assert project.web_test_path == "test/nimble_template_web"
        assert project.mix_project? == false
        assert project.web_project? == true
        assert project.live_project? == true
        assert project.api_project? == false
      end)
    end

    test "given api project, returns valid project with valid modules and paths", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        project = Project.new(api: true)

        assert project.base_module == "NimbleTemplate"
        assert project.base_path == "lib/nimble_template"
        assert project.base_test_path == "test/nimble_template"
        assert project.otp_app == :nimble_template
        assert project.web_module == "NimbleTemplateWeb"
        assert project.web_path == "lib/nimble_template_web"
        assert project.web_test_path == "test/nimble_template_web"
        assert project.mix_project? == false
        assert project.web_project? == false
        assert project.live_project? == false
        assert project.api_project? == true
      end)
    end

    @tag api_project?: true, opts: "--module=SampleCustomModule"
    test "given api project with a custom module name, returns valid project with valid modules and paths",
         %{
           test_project_path: test_project_path
         } do
      in_test_project!(test_project_path, fn ->
        project = Project.new(api: true)

        assert project.base_module == "SampleCustomModule"
        assert project.base_path == "lib/nimble_template"
        assert project.base_test_path == "test/nimble_template"
        assert project.otp_app == :nimble_template
        assert project.web_module == "SampleCustomModuleWeb"
        assert project.web_path == "lib/nimble_template_web"
        assert project.web_test_path == "test/nimble_template_web"
        assert project.mix_project? == false
        assert project.web_project? == false
        assert project.live_project? == false
        assert project.api_project? == true
      end)
    end
  end
end
