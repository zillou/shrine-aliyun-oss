require "shrine"
require "aliyun/oss"
require "down/chunked_io"

class Shrine
  module Storage
    class AliyunOSS
      def initialize(prefix:, **oss_options)
        bucket_name = oss_options.delete(:bucket)
        @prefix = prefix
        @client = Aliyun::OSS::Client.new(**oss_options)
        @bucket = @client.get_bucket(bucket_name)
      end

      def upload(io, id, shrine_metadata: {}, **upload_options)
        content_type = shrine_metadata["mime_type"]

        if copyable?(io)
          bucket.copy_object(io.storage.object_key(io.id), object_key(id))
        else
          bucket.put_object(object_key(id), content_type: content_type) { |stream| stream << io.read }
        end
      end

      def url(id, sign: true, expiry: 900)
        bucket.object_url(object_key(id), sign, expiry)
      end

      # Downloads the file from Aliyun OSS, and returns a `Tempfile`.
      def download(id)
        tempfile = Tempfile.new(["shrine-aliyun-oss", File.extname(id)], binmode: true)
        object = bucket.get_object(object_key(id), file: tempfile)

        tempfile.singleton_class.instance_eval { attr_accessor :content_type }
        tempfile.content_type = object.headers[:content_type]
        tempfile.tap(&:open)
      rescue
        tempfile.close! if tempfile
        raise
      end

      # Returns a `Down::ChunkedIO` object that downloads S3 object content
      # on-demand. By default, read content will be cached onto disk so that
      # it can be rewinded, but if you don't need that you can pass
      # `rewindable: false`.
      def open(id, rewindable: true)
        object = bucket.get_object(object_key(id))
        chunks = Enumerator.new do |y|
          bucket.get_object(object_key(id)) do
            |chunk| y << chunk
          end
        end

        Down::ChunkedIO.new(
          chunks: chunks,
          rewindable: rewindable,
          size:   object.size,
          data: { object: object }
        )
      end

      def exists?(id)
        bucket.object_exists?(object_key(id))
      end

      def delete(id)
        bucket.delete_object(object_key(id))
      end

      def object_key(id)
        prefix ? "#{prefix}/#{id}" : id
      end

      private

      attr_reader :prefix, :bucket

      def copyable?(io)
        io.is_a?(UploadedFile) &&
        io.storage.is_a?(Storage::AliyunOSS)
      end
    end
  end
end
