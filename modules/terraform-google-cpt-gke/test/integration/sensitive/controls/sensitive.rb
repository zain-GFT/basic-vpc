title "Sensitive Resources"

# load the inputs (output by Terraform, stored in inputs.yaml by the pipeline)
project_id = input("project_id")

# Ensure our project exists (sensitive_resources)
control "gcp-project-1.0" do                        # A unique ID for this control
  impact 1.0                                        # The criticality, if this control fails.
  title "Ensure Project exists"                     # A human-readable title

  describe google_project(project: project_id) do
    it { should exist }
  end
end