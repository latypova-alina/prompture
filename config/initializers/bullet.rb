if Rails.env.development? || Rails.env.test?
  Bullet.enable = true
  Bullet.bullet_logger = true
  Bullet.n_plus_one_query_enable = true
  Bullet.unused_eager_loading_enable = false
  Bullet.counter_cache_enable = false
  Bullet.raise = Rails.env.test?
end
