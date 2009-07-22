require 'rubygems'
require 'mechanize'
require 'json'

class FindMyIphone
    def initialize(username, password)
        @username = username
        @password = password
        @agent = WWW::Mechanize.new
        @agent.user_agent_alias = 'Mac Safari'
    end

    def devices
        if !@thedevices
            authurl="https://auth.apple.com/authenticate?service=DockStatus&realm=primary-me&formID=loginForm&username=#{@username}&password=#{@password}&returnURL=aHR0cHM6Ly9zZWN1cmUubWUuY29tL3dvL1dlYk9iamVjdHMvRG9ja1N0YXR1cy53b2Evd2EvdHJhbXBvbGluZT9kZXN0aW5hdGlvblVybD0vYWNjb3VudA%3D%3D"
            page = @agent.get(authurl)
            @isc = @agent.cookie_jar.cookies(URI.parse("https://secure.me.com")).select { |c| c.name == 'isc-secure.me.com' }[0].value

            devicesurl = "https://secure.me.com/wo/WebObjects/DeviceMgmt.woa/?lang=en"
            @agent.pre_connect_hooks << lambda { |params|
                params[:request]['X-Mobileme-Version'] = '1.0'
                params[:request]['X-Mobileme-Isc'] = @isc
                params[:request]['X-Requested-With'] = 'XMLHttpRequest'
                params[:request]['Accept'] = 'text/javascript, text/html, application/xml, text/xml, */*'
            }

            page = @agent.post(devicesurl)
            @thedevices = page.content.match(/tDeviceMgmt.deviceIdMap\['[0-9+]'\] = '([^']+)'/).captures
        end
        return @thedevices
    end

    def sendMessage(msg, alarm=false, device=nil)
        device ||= self.devices[0]

        messageurl = "https://secure.me.com/wo/WebObjects/DeviceMgmt.woa/wa/SendMessageAction/sendMessage"
        data = {"deviceId" => device, 
                             "deviceOsVersion" => "7A341",
                             "message" => msg,
                             "playAlarm" => alarm ? 'Y' : 'N',
        }
        self.send(messageurl,data)
    end

    def locateMe(device = nil)
        device ||= self.devices[0]
        deviceurl = "https://secure.me.com/wo/WebObjects/DeviceMgmt.woa/wa/LocateAction/locateStatus"
        result = {}
        data = {"deviceId" =>  device, "deviceOsVersion" => "7A341" }
        return self.send(deviceurl,data)
    end

    def send(url,data)
        uri = URI.parse(url)
        json = JSON.generate(data)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Post.new(uri.path)
        req.body = "postBody=#{json}"
        req['Cookie'] = @agent.cookie_jar.cookies(URI.parse("https://secure.me.com")).map { |c| c.to_s }.join("; ")
        req['X-Mobileme-Version'] = '1.0'
        req['X-Mobileme-Isc'] = @isc
        req['X-Requested-With'] = 'XMLHttpRequest'
        req['Accept'] = 'text/javascript, text/html, application/xml, text/xml, */*'
        req['Content-type'] = 'application/json'
        res = http.start { |web|
            web.request(req)
        }
        return JSON.parse(res.body)
    end
end
