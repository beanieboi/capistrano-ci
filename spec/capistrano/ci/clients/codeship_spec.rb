require 'spec_helper'

describe Capistrano::CI::Clients::Codeship, :vcr do
  let(:client){ described_class.new ci_access_token: "455d1350-b656-0130-7b14-6616343f2138" }

  describe "#passed?" do
    subject{ client.passed?(branch_name) }

    context "when passed" do
      let(:branch_name){ "master" }

      it{ should == true }
    end

    context "when not passed" do
      let(:branch_name){ "development" }

      it{ should == false }
    end
  end

  describe "#state" do
    let(:branch_name){ "master" }

    subject{ client.state(branch_name) }

    context "when passed" do
      it{ should == "success" }
    end

    context "when not passed" do
      let(:branch_name){ "development" }

      it{ should == "error" }
    end

    context "when branch was not found" do
      let(:branch_name){ "some_branch" }

      it{ should == "branchnotfound" }
    end

    context "when repository was not found" do
      let(:client){ described_class.new ci_access_token: "455d1350-b656-0130-7b14-6616343f21111" }

      it{ should == "projectnotfound" }
    end
  end
end
