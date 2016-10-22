class SearchesController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  require 'cgi'

  def new
  end

  def get
    @text = params[:text]
    encoding_text = CGI.escape(@text)
    puts encoding_text

    url = 'https://public-api.secure.pixiv.net/v1/search/works?q=' + encoding_text + '&sort=date&per_page=3&page=1'
    token = 'Bearer yGJg-FiKrfEYnnITYD0ZPeEOLKTjQr0d9FupYux9gLU'

    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)

    https.use_ssl = true # HTTPSでよろしく
    req = Net::HTTP::Get.new(uri.request_uri)

    req["Authorization"] = token # httpリクエストヘッダの追加
    res = https.request(req)

    # 返却の中身を見てみる
    json = JSON.parse(res.body)
    @response = json['response']
  end

  def get_image
    # url_part = url.slice!(/http:\/\/i1\.pixiv\.net\//)
    @img_url = 'http://i1.pixiv.net/c/150x150/img-master/img/2016/09/01/20/11/43/58763560_p0_master1200.jpg'
    uri = URI.parse(@img_url)
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Referer"] = 'https://public-api.secure.pixiv.net' # httpリクエストヘッダの追加

    @res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    File.open("public/images/image.jpeg", "wb") {|f| f.write(@res.read)}

  end

end
