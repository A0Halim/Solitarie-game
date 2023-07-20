require "ruby2d"

class Kart
  def initialize(address, info = {})
    @imageaddress   = address || nil
    @flippedCardImg = info[:flippedCardImg] || nil
    @address        = info[:address] || nil
    @flipped        = info[:flipped] || false
    @canPlay        = info[:canPlay] || false
    @special        = info[:special] || false
    @pile           = info[:pile] || -1
    @connected      = info[:connected] || nil
    @cardUser       = info[:cardUser] || nil
    @type           = info[:type] || (info[:address] / 13 if info[:address]) || -1
    @value          = info[:value] || (info[:address] % 13 if info[:address]) || -1
    @x              = info[:x] || 0
    @y              = info[:y] || 0
    @z              = info[:z] || 0
    @position       = info[:position] || [@x, @y]
    @color          = info[:color] || "white"
    @opacity        = info[:opacity] || 1
    if @flipped then @image = Image.new(@flippedCardImg, x: @x, y: @y, z: @z, color: @color, opacity: @opacity) else @image = Image.new(@imageaddress, x: @x, y: @y, z: @z, color: @color, opacity: @opacity) end
  end
  
  def followed
    if @connected
      @connected.x = self.x
      @connected.y = self.y + 50
      @connected.followed
    end
  end

  def goPosition
    self.x = @position[0]
    self.y = @position[1]
    if @connected
      @connected.position = [@position[0], @position[1] + 50]
      @connected.goPosition
    end
  end

  def changePile(dizi, gidilenIndex, gelinenIndex)
    dizi[gidilenIndex].unshift(dizi[gelinenIndex].delete(self))
    dizi[gidilenIndex][0].pile = gidilenIndex
    if @connected
      @connected.changePile(dizi, gidilenIndex, gelinenIndex)
    end
  end

  def setLayer
    self.z = -@value
    if @connected
      @connected.setLayer
    end
  end

  def cutConnected
    @cardUser.connected = nil if @cardUser
  end

  def flip
    @flipped = !@flipped
    @image.remove
    if @flipped then @image = Image.new(@flippedCardImg, x: @x, y: @y, z: @z) else @image = Image.new(@imageaddress, x: @x, y: @y, z: @z) end
  end

  def y=(y)         @image.y   = y end
  def z=(z)         @image.z   = z end
  def x=(x)         @image.x   = x end
  def pile=(a)      @pile      = a end
  def canPlay=(a)   @canPlay   = a end
  def position=(a)  @position  = a end
  def cardUser=(a)  @cardUser  = a end
  def connected=(a) @connected = a end

  def y;         @image.y   end
  def z;         @image.z   end
  def x;         @image.x   end
  def pile;      @pile      end
  def type;      @type      end
  def image;     @image     end
  def value;     @value     end
  def special;   @special   end
  def flipped;   @flipped   end
  def address;   @address   end
  def canPlay;   @canPlay   end
  def position;  @position  end
  def cardUser;  @cardUser  end
  def connected; @connected end
end
