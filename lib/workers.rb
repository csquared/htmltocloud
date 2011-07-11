IMGKit.configure do |config|
  config.wkhtmltoimage = Pathname.new(APP_ROOT).join('bin', 'wkhtmltoimage-amd64').to_s if ENV['RACK_ENV'] == 'production'
end

PDFKit.configure do |config|
  config.wkhtmltopdf = Pathname.new(APP_ROOT).join('bin', 'wkhtmltopdf-amd64').to_s if ENV['RACK_ENV'] == 'production'
end

module Workers
  class Create
    def self.perform(user_id, source)
      cloud = CloudStore.new(user_id)
      data = @klass.new(source).send("to_#{@type}")
      cloud.upload_file(cloud.name(source, @type), StringIO.new(data))
      User.get(user_id).created(source, @type)
    end
  end

  class Delete
    def self.perform(user_id, hash)
      CloudStore.new(user_id).delete(hash,@type)
    end
  end

  class CreateIMG < Create
    @queue = 'high'
    @klass = IMGKit
    @type = 'img'
  end  

  class DeleteIMG < Delete
    @queue = 'low'
    @klass = IMGKit
    @type = 'img'
  end

  class CreatePDF < Create
    @queue = 'high'
    @klass = PDFKit
    @type = 'pdf'
  end

  class DeletePDF < Delete
    @queue = 'low'
    @klass = PDFKit
    @type = 'pdf'
  end
end
