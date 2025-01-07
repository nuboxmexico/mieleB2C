task migrate_to_s3: :environment do
  require 'aws-sdk'

  # Define Paperclip models
  models = [
    [BannerImage, :image],
    [PromotionalBanner, :image],
    [PromotionalBanner, :mobile_image],
    [TechnicalDocument, :document],
    [Spree::Image, :attachment]
  ]

  # Load credentials and config
  s3_options        = Rails.application.secrets['aws']['s3_credentials']
  paperclip_options = {
      storage: :s3,
      #s3_host_name: 's3-us-east-1.amazonaws.com',
      s3_headers: { "Cache-Control" => "max-age=31557600" },
      s3_protocol: "https",
      :url => ':s3_alias_url',
      :s3_host_alias => "d146vbe2nx0i1o.cloudfront.net",
      :path =>  "/:class/:attachment/:id_partition/:style/:filename",
      s3_credentials: Rails.application.secrets['aws']['s3_credentials'],
      bucket: 'mieleb2c-cl'
    }
  bucket_name       = paperclip_options[:bucket]

  # Establish S3 connection
  AWS.config(s3_options)
  s3      = AWS::S3.new
  bucket  = s3.buckets[bucket_name]

  models.each do |klass, field|
    styles  = []

    klass.first.send(field).styles.each do |style|
      styles.push(style[0])
    end
    styles.push(:original)

    # Process
    klass.find_each.with_index do |attachment, n|
      styles.each do |style|
        path = attachment.send(field).path(style)
        next if path.nil?

        if klass == Spree::Image
          path_to_load = path
          path = path.split('/')
          path[2] = 'products'
          path = path.join('/')
          root_path = Rails.public_path
        else
          path_to_load = path
          root_path = "#{Rails.public_path}/system"
        end

        begin
          bucket.objects[path_to_load.sub!(%r{^/}, '')].write(file: File.join(root_path, path))
          puts "-> Saved #{path} to S3 (#{n}/#{klass.count})"
        rescue AWS::S3::Errors::NoSuchBucket => e
          puts "--- Creating bucket named: #{bucket_name} ---"
          AWS::S3.new.buckets.create(bucket_name)
          retry
        rescue StandardError => e
          puts "Error on (#{n}/#{klass.count}): #{e}"
        end
      end
    end
  end
end