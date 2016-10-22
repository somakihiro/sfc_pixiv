module SearchesHelper

  def choice_search_words(result)
    nouns = []
    verbs = []
    result.each do |word|
      if word['pos'] == '名詞'
        nouns.push(word['surface'])
      else
        verbs.push(word['surface'])
      end
    end
    puts nouns
    puts verbs
  end

  def get_noun_and_verb(text)
    encoding_text = CGI.escape(text)
    url = 'http://jlp.yahooapis.jp/MAService/V1/parse?appid=dj0zaiZpPVBhTTlleGkwc0J1MSZzPWNvbnN1bWVyc2VjcmV0Jng9Yzg-&sentence=' + encoding_text + '&results=ma&ma_filter=9%7C10'
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.request_uri)

    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    body = res.body.force_encoding("utf-8")

    hash = Hash.from_xml(body)
    result = hash["ResultSet"]["ma_result"]["word_list"]["word"]
    return result
  end

  def search_image(text)
    encoding_text = CGI.escape(text)

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

  def get_image(url)
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Referer"] = 'https://public-api.secure.pixiv.net' # httpリクエストヘッダの追加

    @res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    file_name = url.slice!(/http:\/\/i1\.pixiv\.net\/c\/600x600\/img\-master\/img\//)
    File.open("public/images/#{file_name}", "wb") {|f| f.write(@res.body)}
  end
end
