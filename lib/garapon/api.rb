require 'httpclient'
require 'oj'

module Garapon
  class API

    def initialize(opts = {})
      [:user, :md5passwd, :dev_id].each do |key|
        if opts.has_key?(key) == false
          raise "Error: '#{key}' is not found."
        end

        case key
        when :user
          @user_id = opts[key]
        when :md5passwd
          @passwd = opts[key]
        when :dev_id
          @developer_id = opts[key]
        end
      end

      url = 'http://garagw.garapon.info/getgtvaddress'
      client = HTTPClient.new
      res = client.post_content(url, opts)
      res.each_line do |line|
        key, val = line.chomp.split(';')
        
        case key
        when 1
          raise "Error: #{val}"
        when 'ipaddr'
          @ip = val
        when 'gipaddr'
          @global_ip = val
        when 'pipaddr'
          @private_ip = val
        when 'port'
          @port = val
          @global_port = val
        when 'port2'
          @ts_port = val
        when 'gtvver'
          @version = val
        when '0'
          next
        else
          raise "WARNING: unknown response: #{key} = #{val}"
        end
      end

      if @ip == @private_ip
        @port = 80
      end
    end

    def channel_list
      login
      
      url = "http://#{@ip}:#{@port}/gapi/v3/channel?dev_id=#{@developer_id}&gtvsession=#{@session}"
      client = HTTPClient.new
      res_str = client.get_content(url)
      res = Oj.load(res_str, :mode => :compat)

      return res
    end

    def search(condition)
      login

      url = "http://#{@ip}:#{@port}/gapi/v3/search?dev_id=#{@developer_id}&gtvsession=#{@session}"
      client = HTTPClient.new
      res_str = client.post_content(url, condition)
      res = Oj.load(res_str, :mode => :compat)
      
      if res['status'] != 1
        raise "Error: Can not get response for search: status=#{res['status']}"
      end

      return res
    end

    private

    def login
      url = "http://#{@ip}:#{@port}/gapi/v3/auth?dev_id=#{@developer_id}"
      post_data = {
        :type    => 'login',
        :loginid => @user_id,
        :md5pswd => @passwd
      }

      client  = HTTPClient.new
      res_str = client.post_content(url, post_data)
      res     = Oj.load(res_str, :mode => :compat)
      
      @session = res['gtvsession']
    end
  end
end
