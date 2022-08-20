# get, parse and show exchanges from tcmb
class TCMB_exchanger
  require 'json'
  require 'crack'
  require 'ostruct'
  require 'net/http'

  attr_reader :exchanges

  LINK      = 'https://www.tcmb.gov.tr/kurlar/today.xml'.freeze
  Hierarcy  = ['Tarih_Date', 'Currency'].freeze

  VAR_NAMES = {
    'Isim'            => 'isim',
    'CurrencyName'    => 'name',
    'ForexBuying'     => 'for_buy',
    'ForexSelling'    => 'for_sel',
    'BanknoteBuying'  => 'bank_buy',
    'BanknoteSelling' => 'bank_sell',
    'CrossRateUSD'    => 'cross_usd',
    'CrossRateOther'  => 'cross_other',
    'CrossOrder'      => 'order',
    'Kod'             => 'kod',
    'CurrencyCode'    => 'code'
  }.freeze

  def initialize(
          function_names: VAR_NAMES,
          write_cache: false,
          cache_folder: nil
  )
    @var_names    = function_names
    @write_cache  = write_cache
    @cache_folder = cache_folder

    @cache_file   = set_cache_file_name
    @exchanges    = {}
  end

  def process
    # get exchanges or read the cache file
    get_body
    cache
    rename_param
    xml2obj
  end

  private

  # write @body to cache file
  def cache
    return false unless @write_cache

    return false unless @body

    return true if File.exists? @cache_file

    File.open(@cache_file, 'w') { |cache| cache.write @body }
  end

  # make new cache file name
  def set_cache_file_name
    @cache_file = (@cache_folder ? @cache_folder + '/' : '') + "today_#{Time.new.strftime '%y.%m.%d'}.xml"
  end

  # parse xml to object
  def xml2obj
    xml_content = parse_exchanges
    data = get_pure_data(xml_content)

    kod_name = @var_names ? @var_names['Kod'] : 'Kod'

    data.each do |line|
      name = line[kod_name]
      @exchanges[name] = line
      set_ins(name, str2obj(line))
    end
  end

  # rename exchange values and functions names
  def rename_param
    return unless @var_names
    @var_names.each { |old_val, new_val| @body.gsub!(old_val, new_val) }
    true
  end

  # convert string to open struct object
  def str2obj(obj_str)
    JSON.parse(obj_str.to_json, object_class: OpenStruct)
  end

  # set variables as instance variable
  def set_ins(name, obj)
    name = name.dup.downcase
    self.class.__send__(:attr_reader, name)
    instance_variable_set('@' + name, obj)
  end

  # dig xml hierarchy into hash
  def get_pure_data(data)
    Hierarcy.each { |str| data = data[str] }
    return data
  rescue
    throw 'Unknowing exchange type'
  end

  # convert @body to xml hash
  def parse_exchanges
    Crack::XML.parse(@body)
  rescue
    throw 'XML parse error!'
  end

  # select body source and get
  def get_body
    @body =
      if File.exist? @cache_file
        File.read @cache_file # get @body from file
      else
        Net::HTTP.get(URI.parse(LINK)) # get @body from url link
      end
  end
end
