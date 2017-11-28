require 'yaml'
require './KiwiImport/lib/sle_repository_replacer.rb'

RSpec.describe SleRepositoryReplacer do
  let(:repository_map) { YAML.load(File.new('./KiwiImport/config/config.yml').read)["sle_repositories"] }

  describe '#replace!' do
    context 'for a SLE kiwi config' do
      let(:input) { File.read('./spec/fixtures/sle_config_input.xml').to_s }
      let(:output) { File.read('./spec/fixtures/sle_config_output.xml').to_s }
      let(:replacer) { SleRepositoryReplacer.new(input, repository_map) }

      it 'does replace SLE repository placeholders' do
        expect {
          replacer.replace!
        }.to change { replacer.config.strip! }.from(input).to(output.strip!)
      end
    end

    context 'for an openSUSE kiwi config' do
      let(:replacer) { SleRepositoryReplacer.new('oemboot/suse-openSUSE', repository_map) }

      it 'does not change the config file' do
        expect {
          replacer.replace!
        }.not_to change { replacer.config }
      end
    end
  end
end
