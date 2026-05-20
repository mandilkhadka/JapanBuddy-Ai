require "test_helper"

class LocaleParityTest < ActiveSupport::TestCase
  LOCALES = %w[en ja ne].freeze

  def flatten_keys(hash, prefix = "")
    keys = []
    hash.each do |k, v|
      full = prefix.empty? ? k.to_s : "#{prefix}.#{k}"
      case v
      when Hash
        keys.concat(flatten_keys(v, full))
      when Array
        v.each_with_index do |item, i|
          if item.is_a?(Hash)
            keys.concat(flatten_keys(item, "#{full}[#{i}]"))
          else
            keys << "#{full}[#{i}]"
          end
        end
      else
        keys << full
      end
    end
    keys
  end

  test "all locale files declare the same key set" do
    key_sets = LOCALES.map do |l|
      data = YAML.load_file(Rails.root.join("config/locales/#{l}.yml"))[l]
      [l, flatten_keys(data).to_set]
    end.to_h

    all_keys = key_sets.values.reduce(:|)

    diffs = LOCALES.map do |l|
      missing = (all_keys - key_sets[l]).sort
      missing.empty? ? nil : "#{l}: missing #{missing.join(', ')}"
    end.compact

    assert_empty diffs, "Locale key parity mismatch:\n#{diffs.join("\n")}"
  end
end
