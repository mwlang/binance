def test_api_key
  "vmPUZE6mv9SD5VNHk4HlWFsOr6aKE2zvsw0MuIgwCIPy6utIco14y7Ju91duEh8A"
end

def test_api_secret
  "NhqPtmdSJYdKjVHjA7PZj4Mge3R5YNiP1e3UZjInClVN65XAbvqqM6A7H5fATj0j"
end

def api_key
  api_from_yaml.api_key
end

def api_secret
  api_from_yaml.api_secret
end

def api_yaml_filename
  File.expand_path("./spec/test.yml")
end

class ApiKey
  include YAML::Serializable

  @[YAML::Field(key: "api_key")]
  property api_key : String

  @[YAML::Field(key: "api_secret")]
  property api_secret : String
end

def api_from_yaml
  if File.exists?(api_yaml_filename)
    ApiKey.from_yaml(File.read(api_yaml_filename))
  else
    ApiKey.from_yaml("api_key: \"#{test_api_key}\"\napi_secret: \"#{test_api_secret}\"")
  end
end
