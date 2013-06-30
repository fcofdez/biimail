$repository = Repository.new
$server = RemoteServer.new

CONFIG = YAML.load_file("#{Rails.root}/config/remote_server.yml")

