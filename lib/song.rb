class Song
    attr_accessor :name, :artist, :genre

    @@all = []

    def initialize(name, artist = nil, genre = nil)
        @name = name
        self.artist = artist if artist
        self.genre = genre if genre
    end

    def self.all
        @@all
    end

    def self.destroy_all 
        @@all.clear
    end

    def save
        self.class.all << self
    end

    def self.create(name)
        song = self.new(name)
        song.save
        song
    end

    def artist=(artist)
        @artist = artist
        artist.add_song(self)
    end

    def genre=(genre)
        @genre = genre
        @genre.songs << self unless genre.songs.include?(self)
    end

    def self.find_by_name(name)
        self.all.find do |song|
            song.name == name
        end
    end

    def self.find_or_create_by_name(name)
      self.find_by_name(name) || self.create(name)
    end

    def self.new_from_filename(filename)
        song_parts = filename.split(" - ")
        artist_name, song_name, genre_name = song_parts[0], song_parts[1], song_parts[2].gsub(".mp3", "")

        artist = Artist.find_or_create_by_name(artist_name)
        genre = Genre.find_or_create_by_name(genre_name)

        new(song_name, artist, genre)

    end

    def self.create_from_filename(filename)
        self.new_from_filename(filename).tap{|song| song.save}  
    end
    
     
end