class MarvelParams
  def self.public_key
    ENV['MARVEL_PUBLIC_KEY']
  end

  def self.private_key
    ENV['MARVEL_PRIVATE_KEY']
  end

  def self.timestamp
    DateTime.now.to_s
  end

  def self.digest
    Digest::MD5.hexdigest( "#{timestamp}#{private_key}#{public_key}" )
  end

  def self.credentials
    "ts=#{MarvelParams.timestamp}&apikey=#{MarvelParams.public_key}&hash=#{MarvelParams.digest}"
  end
end
