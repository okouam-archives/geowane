require 'mime/types'

#
# Built with massive inspiration (ok, more like following their lead) from the following:
# - https://github.com/JackDanger/file-uploader/commit/03ed9ba68d46805e22a0014ac0eee9ecbd5acd8d
# - https://github.com/newbamboo/example-html5-upload/blob/master/lib/rack/raw_upload.rb
#
class RawFileUpload
  def initialize(app)
    @app = app
  end

  def call(env)
    if raw_file_post?(env)
      convert_and_call(env)
    else
      @app.call(env)
    end
  end

private
  def raw_file_post?(env)
    env['HTTP_X_FILE_NAME'] &&
      env['CONTENT_TYPE'] == 'application/octet-stream' &&
      env['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest'
  end

  def convert_and_call(env)
    tempfile = Tempfile.new('raw-upload.')
    env['rack.input'].each do |chunk|
      tempfile << chunk.force_encoding('UTF-8')
    end
    tempfile.flush
    tempfile.rewind

    multipart_hash = {
      :image => {
        :filename => env['HTTP_X_FILE_NAME'],
        :type => MIME::Types.type_for(env['HTTP_X_FILE_NAME']).first,
        :tempfile => tempfile
      }
    }

    env['rack.request.form_input'] = env['rack.input']

    env['rack.request.form_hash'] ||= {}
    env['rack.request.query_hash'] ||= {}

    env['rack.request.form_hash']['photo'] = multipart_hash
    env['rack.request.query_hash']['photo'] = multipart_hash

    @app.call(env)
  end
end


Rails.application.config.middleware.use RawFileUpload