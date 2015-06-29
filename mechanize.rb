require "mechanize"

agent = Mechanize.new {|agent| agent.user_agent = "Mac Safari"}

random_proxies = ["202.238.92.36", "42.119.67.6", "221.155.148.150", "50.188.22.176", "62.45.127.88", "86.167.58.7", "109.252.74.213"]
random_sites = ["http://target.com", "http://bestbuy.com", "http://forbes.com", "http://theverge.com", "http://hoge.com", "http://mascus.com", "http://recycler.com"]
random_users = ["timanderson@gmail.com", "john.miller@gmail.com", "jackson.emmit@gmail.com", "fernandot@gmail.com"]
random_password = ["password123", "thisismylife", "jerseyshore", "wooooo"]
agent.set_proxy("#{random_proxies.sample}", 80, "#{random_users.sample}", "#{random_password.sample}")
agent.add_auth("#{random_sites.sample}", "#{random_users.sample}", "#{random_password.sample}")

page = agent.get("http://forbes.com")

puts page.at("div")


