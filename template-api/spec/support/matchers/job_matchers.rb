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
    expected = Array(expected).flatten
    actual = Array(actual)

    matching_jobs = actual.select do |job|
      klass, arguments = job_klass(job)
      if expected.size == 1
        klass.to_s == expected[0].to_s
      else
        klass.to_s == expected[0].to_s && (expected[1..] - arguments).empty?
      end
    end

    !matching_jobs.empty?
  end

  failure_message do |actual|
    "expected that #{actual} would include job #{expected}"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not include job #{expected}"
  end

  description do
    "include job #{expected}"
  end
end
