class PictureStoriesController < ApplicationController

  def home
  end

  def new
    @picture_story = PictureStory.new
    3.times { @picture_story.picture_story_orders.build }
  end

  def create
    orders_attributes = params[:picture_story][:picture_story_orders_attributes]
    orders_attributes.each do |key, value|
      text = value[:story]
      words = get_words(text)
      words ||= {'surface' => '面白'}
      search_words = find_search_words(words)
      count = search_words.length
      if count >= 3
        @output = get_choice(search_words, 3)
      elsif count >= 2
        @output = get_choice(search_words, 2)
      else
        @output = get_choice(search_words, 1)
      end
      url = search_image(@output)
      if !url
        @output = get_choice(search_words, 1)
        url = search_image(@output)
      end
      file_name = save_image_and_get_file_name(url)
      orders_attributes[key][:image] = file_name
    end
    @picture_story = PictureStory.create(picture_story_params)
    redirect_to @picture_story
  end

  def show
    @picture_story = PictureStory.find(params[:id])
    orders = @picture_story.picture_story_orders
    orders.each do |order|
      save_image_and_get_file_name(order[:image])
    end
  end

  def index
    @picture_stories = PictureStory.all
  end

  private

    def picture_story_params
      params.require(:picture_story).permit(:title, picture_story_orders_attributes: [:id, :story, :image, :_destroy])
    end

    def get_words(text)
      encoding_text = CGI.escape(text)
      url = 'http://jlp.yahooapis.jp/MAService/V1/parse?appid=dj0zaiZpPVBhTTlleGkwc0J1MSZzPWNvbnN1bWVyc2VjcmV0Jng9Yzg-&sentence=' + encoding_text + '&results=ma&ma_filter=1%7C2%7C9%7C10'
      uri = URI.parse(url)
      req = Net::HTTP::Get.new(uri.request_uri)

      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end

      body = res.body.force_encoding("utf-8")

      hash = Hash.from_xml(body)
      if hash["ResultSet"]["ma_result"]["word_list"].nil?
        return false
      end
      result = hash["ResultSet"]["ma_result"]["word_list"]["word"]
      return result
    end

    def find_search_words(result)
      words = []
      if result.is_a?(Array)
        result.each do |word|
          next if word['pos'] != '名詞' && word['surface'].length == 1
          words.push(word['surface'])
        end
      else
        words.push(result['surface'])
      end
      return words
    end

    def get_choice(words, num)
      choices = words.sample(num)
      output = ""
      choices.each do |word|
        output += word
        output += " "
      end
      return output
    end

    def search_image(text)
      encoding_text = CGI.escape(text)

      url = "https://public-api.secure.pixiv.net/v1/search/works?q=#{encoding_text}&sort=date&per_page=20&page=1&image_sizes=small,medium&mode=text"
      token = 'Bearer yGJg-FiKrfEYnnITYD0ZPeEOLKTjQr0d9FupYux9gLU'

      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)

      https.use_ssl = true # HTTPSでよろしく
      req = Net::HTTP::Get.new(uri.request_uri)

      req["Authorization"] = token # httpリクエストヘッダの追加
      res = https.request(req)

      # 返却の中身を見てみる
      json = JSON.parse(res.body)
      puts json
      count = json['count']
      return false if count == 0
      image = json['response'].sample
      image_urls = image['image_urls']
      return image_urls['medium']
    end

    def save_image_and_get_file_name(url)
      uri = URI.parse(url)
      req = Net::HTTP::Get.new(uri.request_uri)
      req["Referer"] = 'https://public-api.secure.pixiv.net' # httpリクエストヘッダの追加

      @res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end

      file_name = url.gsub(/[\s\/]/, '')
      File.open("public/images/#{file_name}", "wb") {|f| f.write(@res.body)}
      return url
    end

end
