require 'json'
require 'hash-joiner'
require 'open-uri'

module Jekyll_Get
  class Generator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      config = site.config['jekyll_get']
      if !config
        return
      end
      if !config.kind_of?(Array)
        config = [config]
      end
      config.each do |d|
        data_source = (site.config['data_source'] || '_data')
        path = "#{data_source}/#{d['data']}.json"
        if d['cache'] && File.exists?(path)
          source = JSON.load(File.open(path))
        else
          source = JSON.load(open(d['json']))
        end
        site.data[d['data']] = source
        if d['cache']
          open(path, 'wb') do |file|
            file << JSON.generate(site.data[d['data']])
          end
        end
      end
    end
  end
end
