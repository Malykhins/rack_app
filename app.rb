require 'rack'

class TimeApp
  def call(env)
    request = Rack::Request.new(env)
    all_formats = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'minute' => '%M', 'second' => '%S' }

    if request.path == '/time' && request.get?
      format = request.params['format'].split('%')
      time = Time.now
      result = []
      unknown_formats = []

      format.each do |f|
        if all_formats.include?(f)
          result << time.strftime(all_formats[f])
        else
          unknown_formats << f
        end
      end

    else
      return [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
    end

    if unknown_formats.any?
      [400, { 'Content-Type' => 'text/plain' }, ["Unknown time format #{unknown_formats.inspect}"]]
    elsif result.any?
      response = result.join('-')
      [200, { 'Content-Type' => 'text/plain' }, [response]]
    end
  end
end
