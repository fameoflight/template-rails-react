# frozen_string_literal: true

module CommonSpecHelpers
  def json_fixture(filename)
    filename = filename.chomp('.json')

    file_content = file_fixture("#{filename}.json").read
    JSON.parse(file_content, symbolize_names: true).with_indifferent_access
  end

  def write_json_fixture(filename, content)
    filename = filename.chomp('.json')

    file_path = file_fixture("#{filename}.json").to_s

    content = content.to_json if content.is_a? Hash

    content = JSON.pretty_generate(JSON.parse(content))

    File.write(file_path, content)
  end

  def use_multiple_cassettes(*args, **kwargs)
    cassettes = args.flatten

    # Use :record => :new_episodes to record new cassettes
    record = kwargs.delete(:record) || :once

    cassettes.each do |cassette|
      VCR.insert_cassette(cassette, record:, **kwargs)
    end

    begin
      yield
    ensure
      cassettes.each do |cassette|
        VCR.eject_cassette(cassette)
      end
    end
  end

  def with_versioning
    was_enabled = PaperTrail.enabled?
    was_enabled_for_request = PaperTrail.request.enabled?
    PaperTrail.enabled = true
    PaperTrail.request.enabled = true
    begin
      yield
    ensure
      PaperTrail.enabled = was_enabled
      PaperTrail.request.enabled = was_enabled_for_request
    end
  end

  def log(*args, **kwargs)
    default_tag = try(:described_class).to_s || 'SPEC'

    kwargs[:level] ||= :stdout

    kwargs[:tag] ||= default_tag

    kwargs[:color] ||= :light_blue

    ConsolePrint.log(*args, **kwargs)
  end

  def get_super_user
    User.create_or_update_by!(
      { email: 'admin@test.com' },
      update: {
        name: 'Admin User',
        password: 'testtest',
        confirmed_at: Time.zone.now
      }
    )
  end
end
