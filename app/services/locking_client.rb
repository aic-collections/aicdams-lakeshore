# frozen_string_literal: true
# Defines our own locking client that waits a fixed amount of time, rather than a random amount.
# Note: the lock_retry_delay configuration value now has no effect since we're hard-coding this to 1
require 'redis'
require 'securerandom'

class LockingClient < Redlock::Client
  private

    def try_lock_instances(resource, ttl, options)
      tries = options[:extend] ? 1 : @retry_count

      count = 1

      tries.times do
        lock_info = lock_instances(resource, ttl, options)
        return lock_info if lock_info

        # Wait one second before re-trying
        count += 1
        logger.info("LockingClient: Couldn't get a lock on #{resource}. Trying #{count}/#{tries}")
        sleep(1)
      end

      false
    end

    def logger
      @logger ||= Logger.new(File.join(Rails.root, "log", "lock.log"))
    end
end
