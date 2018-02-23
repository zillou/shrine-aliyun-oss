# Shrine::Storage::AliyunOSS

Provides [Alibaba cloud object storage] for [Shrine].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shrine-aliyun-oss'
```

## Usage

```ruby
require "shrine"
require "shrine/storage/aliyun_oss"

oss_options = {
  endpoint: "oss-<region-name>.aliyuncs.com",
  access_key_id: "<access_key_id>",
  access_key_secret: "<access_key_secret>",
  bucket: "<bucket-name>"
}

Shrine.storages = {
  cache: Shrine::Storage::AliyunOSS.new(prefix: "cache", **oss_options),
  store: Shrine::Storage::AliyunOSS.new(prefix: "store", **oss_options)
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zillou/shrine-aliyun-oss.

## License

- [MIT](http://opensource.org/licenses/MIT)

[Alibaba cloud object storage]: https://www.alibabacloud.com/product/oss
[Shrine]: https://github.com/janko-m/shrine

