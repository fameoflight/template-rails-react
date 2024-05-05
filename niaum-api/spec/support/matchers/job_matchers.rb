# frozen_string_literal: true

def job_klass(job)
  arguments = job['arguments']

  if job['job_class'] == 'ActionMailer::MailDeliveryJob'
    [arguments[0], arguments[1..]]
  else
    [job['job_class'], arguments]
  end
end

RSpec::Matchers.define :includes_job do |expected|
  match do |actual|
    actual = [actual] unless actual.is_a?(Array)

    matching_jobs = actual.select do |job|
      klass, arguments = job_klass(job)

      klass == expected[0] && expected[1..].all? { |arg| arguments.include?(arg) }
    end

    expect(matching_jobs.size).not_to eq(0)
  end
end
