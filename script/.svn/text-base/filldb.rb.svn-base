ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

Role.delete_all
r = Role.create({
  name: "Test Role",
  admin: true,
  can_setup: true,
  can_run_reports: true,
  pay_rate: 0
})

User.delete_all
u = User.create({
  username: "test",
  first: "Test",
  last: "User",
  password: "wmp",
  password_confirmation: "wmp",
  role: r
})

Client.delete_all
c = Client.create({
  name: "Test Client",
  code: "TC"
})

Project.delete_all
p = Project.create({
  name: "Test Project",
  client: c
})

Task.delete_all
t = Task.create({
  name: "Test Task",
  project: p
})

u.projects << p
u.save