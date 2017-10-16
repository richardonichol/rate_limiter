class HomeController < ApplicationController

  before_action :rate_limiter

  def index
    render(json: { message: 'ok' })
  end

  protected

  # Realistically, a production app is more likely to implement this in a common controller concern or possibly using rack,
  # as we would more than likely want to rate limit other actions.
  def rate_limiter
    if ip_is_blocked?
      render status: 429, json: { message: "Rate limit exceeded. Try again in #{seconds_left_in_hour} seconds." }
      return false
    end
    set_or_increment_counters
  end

  private # Methods we do not intend to test directly.

  def ip_is_blocked?
    $redis.get(blocked_ip_key)
  end

  def set_or_increment_counters
    if redis_ip_key
      if requests > allowed_requests
        block_ip_address
      end
    else # no key exists so set it along with an expiry time
      $redis.set(ip_key,1)
      $redis.expire(ip_key,limit_span)
    end
  end

  def redis_ip_key
    $redis.get(ip_key)
  end

  def requests
    $redis.incr(ip_key)
  end

  def block_ip_address
    $redis.set(blocked_ip_key,1)
    $redis.expire(blocked_ip_key,seconds_left_in_hour)
  end

  def limit_span
    3600
  end

  def allowed_requests
    100
  end

  def ip_key
    "ip:#{request.remote_ip}"
  end

  def blocked_ip_key
    "blocked_ip:#{request.remote_ip}"
  end

  def seconds_left_in_hour
    time = Time.now
    3600 - time.min * time.sec
  end
end