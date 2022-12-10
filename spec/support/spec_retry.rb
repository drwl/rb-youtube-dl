require 'rspec/retry'

module Spec
  module Support
    module SpecRetry
    end
  end
end

RSpec.configure do |config|
  config.include(Spec::Support::SpecRetry)

  # show retry status in spec process
  config.verbose_retry = true
  # show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true
end
