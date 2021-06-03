title "Main Resources"

project_id = input('project_id')
location = input('location')
cluster_name = input('cluster_name')
nodepool_name = input('nodepool_name')

control "private-cluster-tests-1.0" do
  impact 1.0
  title "Google Compute Engine GKE configuration"

  describe google_container_cluster(project: project_id, location: location, name: cluster_name) do
    it { should exist }
    its('status') { should eq 'RUNNING' }
    its('private_cluster_config.enable_private_endpoint') { should eq true }
    its('private_cluster_config.enable_private_nodes') { should eq true }
    its('default_max_pods_constraint.max_pods_per_node') { should eq "30" }
  end

  describe google_container_node_pool(project: project_id, location: location, cluster_name: cluster_name, nodepool_name: nodepool_name[0]) do
    it { should exist }
    its('autoscaling.enabled') { should eq true }
    its('autoscaling.min_node_count') { should eq 1 }
    its('autoscaling.max_node_count') { should eq 1 }
    its('config.machine_type') { should eq "e2-medium" }
    its('config.disk_size_gb') { should eq 100 }
    its('management.auto_repair') { should eq true }
    its('max_pods_constraint.max_pods_per_node') { should eq "30" }
  end

end
